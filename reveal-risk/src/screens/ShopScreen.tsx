import React from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { useGameStore } from '../store/useGameStore';

/** Gem shop: spend the currency on streak freezes and shield refills. */
export function ShopScreen() {
  const gems = useGameStore((s) => s.gems);
  const streakFreezes = useGameStore((s) => s.streakFreezes);
  const hearts = useGameStore((s) => s.hearts);
  const buyFreeze = useGameStore((s) => s.buyStreakFreeze);
  const buyHeart = useGameStore((s) => s.buyHeartRefill);

  return (
    <ScrollView style={styles.container} contentContainerStyle={{ padding: 16, gap: 16 }}>
      <View style={styles.balance}>
        <Text style={styles.balanceLabel}>YOUR GEMS</Text>
        <Text style={styles.balanceValue}>💎 {gems}</Text>
        <Text style={styles.balanceHint}>Earn gems from lessons and daily-quest chests.</Text>
      </View>

      <ShopItem
        icon="🧊"
        name="Streak Freeze"
        desc="Protects your streak if you miss a day — used automatically when needed."
        owned={streakFreezes}
        cost={50}
        canBuy={gems >= 50}
        onBuy={buyFreeze}
      />

      <ShopItem
        icon="❤️"
        name="Refill Shields"
        desc={`Restore all shields to full (you have ${hearts}/3).`}
        cost={100}
        canBuy={gems >= 100 && hearts < 3}
        note={hearts >= 3 ? 'Shields already full' : undefined}
        onBuy={buyHeart}
      />
    </ScrollView>
  );
}

function ShopItem({
  icon,
  name,
  desc,
  cost,
  canBuy,
  owned,
  note,
  onBuy,
}: {
  icon: string;
  name: string;
  desc: string;
  cost: number;
  canBuy: boolean;
  owned?: number;
  note?: string;
  onBuy: () => boolean;
}) {
  return (
    <View style={styles.item}>
      <View style={styles.itemIconWrap}>
        <Text style={styles.itemIcon}>{icon}</Text>
      </View>
      <View style={{ flex: 1 }}>
        <View style={styles.itemHead}>
          <Text style={styles.itemName}>{name}</Text>
          {owned !== undefined && owned > 0 && (
            <View style={styles.ownedBadge}>
              <Text style={styles.ownedText}>×{owned}</Text>
            </View>
          )}
        </View>
        <Text style={styles.itemDesc}>{desc}</Text>
        <Pressable
          disabled={!canBuy}
          onPress={() => onBuy()}
          style={[styles.buyBtn, !canBuy && styles.buyBtnDisabled]}
        >
          <Text style={[styles.buyText, !canBuy && { color: colors.textMuted }]}>
            {note ?? `Buy · 💎 ${cost}`}
          </Text>
        </Pressable>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.bg },
  balance: { backgroundColor: colors.navy, borderRadius: radius.lg, padding: 18, alignItems: 'center' },
  balanceLabel: { color: 'rgba(255,255,255,0.7)', fontSize: font.tiny, fontWeight: '800', letterSpacing: 1 },
  balanceValue: { color: '#fff', fontSize: 40, fontWeight: '900', marginTop: 2 },
  balanceHint: { color: 'rgba(255,255,255,0.7)', fontSize: font.small, marginTop: 4, textAlign: 'center' },
  item: {
    flexDirection: 'row',
    gap: 12,
    backgroundColor: colors.surface,
    borderRadius: radius.lg,
    borderWidth: 1,
    borderColor: colors.border,
    padding: 14,
  },
  itemIconWrap: {
    width: 52,
    height: 52,
    borderRadius: radius.md,
    backgroundColor: colors.surfaceAlt,
    alignItems: 'center',
    justifyContent: 'center',
  },
  itemIcon: { fontSize: 28 },
  itemHead: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  itemName: { fontSize: font.h3, fontWeight: '800', color: colors.text },
  ownedBadge: { backgroundColor: colors.gem, borderRadius: radius.pill, paddingHorizontal: 8, paddingVertical: 1 },
  ownedText: { color: '#fff', fontSize: font.tiny, fontWeight: '900' },
  itemDesc: { fontSize: font.small, color: colors.textMuted, marginTop: 2, lineHeight: 18 },
  buyBtn: { marginTop: 10, backgroundColor: colors.primary, borderRadius: radius.md, paddingVertical: 10, alignItems: 'center' },
  buyBtnDisabled: { backgroundColor: colors.surfaceAlt },
  buyText: { color: '#fff', fontWeight: '800', fontSize: font.body },
});
