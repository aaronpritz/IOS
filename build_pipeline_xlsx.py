#!/usr/bin/env python3
"""Generate the Active Deals pipeline spreadsheet from HubSpot data (snapshot 2026-06-15)."""
from datetime import date
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

TODAY = date(2026, 6, 15)

OWNERS = {
    "181461389": "Cody Rivers",
    "117983497": "Chris Adickes",
    "77029996": "Todd Wilkinson",
    "66540662": "Michael Milroy",
    "50024408": "Aaron Pritz",
}
STAGES = {
    "13068186": "Sales Qualified",
    "15636527": "Scoping",
    "1182680698": "Validation",
    "decisionmakerboughtin": "Closing",
}
DEALTYPE = {"newbusiness": "New", "existingbusiness": "Existing", "": ""}

# id, name, amount, stage, prob, score, owner, dealtype, close, created, last_act, next_act, contacts, next_step
DEALS = [
 (21779414845,"Republic Airlines - 2-3 year program deal",620000,"13068186",0.10,2,"181461389","existingbusiness","2028-06-28","2024-08-28","2026-06-12","2026-06-16",1,"Sept 6 workshop will set direction for the 3-year program (with volume discounts)."),
 (60688516944,"Aurorium - vCISO 26-27 - 3 Year Deal",585000,"15636527",0.40,32,"181461389","existingbusiness","2026-08-26","2026-05-28","","2026-07-07",1,""),
 (51315671149,"Allegion - Merger and acquisition support",500000,"1182680698",0.65,35,"181461389","existingbusiness","2026-06-30","2025-12-05","2026-05-08","2026-06-19",1,"Propose expanding M&A scope to include CMMC + NIS2 + CSF gap assessment; draft scope amendment."),
 (59171638042,"Elanco - NIS2 Engagement - RFI",300000,"1182680698",0.65,58,"117983497","existingbusiness","2026-07-01","2026-04-14","2026-06-15","2026-06-16",1,""),
 (20444408728,"CICP vCISO 2027",250000,"13068186",0.10,35,"181461389","existingbusiness","2026-12-18","2024-06-30","2026-06-15","2026-06-17",1,""),
 (59171649292,"Eli Lilly - NIS2",245000,"1182680698",0.65,29,"181461389","existingbusiness","2026-07-13","2026-04-14","2026-06-05","2026-06-17",1,""),
 (43288840532,"Takeda - Office of the CISO",200000,"1182680698",0.65,45,"117983497","existingbusiness","2026-07-20","2025-09-04","2026-06-11","2026-06-18",1,"Meeting with Jen bumped due to incident. Follow up Tuesday to confirm meeting and status."),
 (60647515018,"Macy's - NIST Assessment w/CCPA",160000,"1182680698",0.65,67,"181461389","newbusiness","2026-07-03","2026-05-26","","2026-06-22",1,""),
 (51628024244,"McLaren - NIST CSF Assessment & Strategy",150000,"1182680698",0.65,32,"181461389","newbusiness","2026-12-11","2025-12-10","2026-05-13","2026-07-17",1,""),
 (61053993904,"Warrant - CMMC Program Support",150000,"15636527",0.40,54,"181461389","newbusiness","2026-06-26","2026-06-12","","",1,""),
 (55827642373,"Zoetis - Office of the CISO",150000,"13068186",0.10,30,"181461389","newbusiness","2026-06-22","2026-02-09","2026-06-15","",2,""),
 (59369996406,"Viatris - NIS2 Execution",105000,"decisionmakerboughtin",0.85,81,"181461389","existingbusiness","2026-06-19","2026-04-21","2026-06-15","2026-06-22",2,""),
 (41880107426,"University of Michigan - Modernized Data Security Strategy",100000,"13068186",0.10,4,"117983497","newbusiness","2027-04-05","2025-08-12","2026-05-26","",1,""),
 (51075868997,"Rolls-Royce Awareness Program Assessment/Strategy",100000,"13068186",0.10,12,"181461389","","","2025-12-03","2026-02-02","",0,""),
 (48359551007,"IU Health - HIPAA SRA 2026",100000,"15636527",0.40,44,"181461389","existingbusiness","2026-10-02","2025-11-05","2026-03-23","2026-07-27",2,""),
 (55882035287,"Zoetis - NIST CSF",100000,"13068186",0.10,32,"77029996","newbusiness","2026-07-13","2026-02-09","2026-04-30","",0,""),
 (39257771013,"Republic Airways - Identity and PAM strategy",90000,"13068186",0.10,8,"77029996","","2026-08-10","2025-06-24","","2026-06-30",0,""),
 (50713841430,"Sallie Mae - Controls Mapping, Automation Planning, and CRI",90000,"1182680698",0.65,64,"77029996","newbusiness","2026-06-30","2025-12-01","2026-06-11","2026-06-17",3,""),
 (55653113433,"PPPSGV - vCISO 2026-2027",85000,"15636527",0.40,29,"181461389","existingbusiness","2026-06-26","2026-02-06","2026-05-28","",1,""),
 (53265172049,"Takeda - 2026 Awareness Program Enhancements",80000,"13068186",0.10,12,"117983497","existingbusiness","2026-08-03","2026-01-06","2026-06-02","",1,""),
 (53268544542,"Republic Airways - SecOps Execution",80000,"1182680698",0.65,40,"77029996","existingbusiness","2026-06-22","2026-01-05","2026-06-09","2026-06-18",0,""),
 (41881978888,"University of Michigan - Cyber Technology Stack Rationalization",75000,"13068186",0.10,22,"117983497","newbusiness","2026-07-06","2025-08-12","2026-05-26","",1,""),
 (57093259329,"Zook Disk - Cyber Advisory",75000,"1182680698",0.65,25,"181461389","existingbusiness","2026-09-11","2026-02-26","2026-05-26","",1,""),
 (60959922331,"Magruder Hospital - Arctic Wolf 2026-2029",75000,"1182680698",0.65,79,"66540662","newbusiness","2026-06-30","2026-06-08","","",0,""),
 (60959905682,"Hendricks - BIA and Strategy",75000,"15636527",0.40,30,"181461389","existingbusiness","2026-09-06","2026-06-08","2026-06-11","2026-06-18",1,""),
 (44585883811,"Kidde Global Solutions - Awareness Improvements",75000,"13068186",0.10,9,"117983497","newbusiness","2026-07-27","2025-09-26","2025-09-17","",1,""),
 (60644309008,"Viatris - GRC Advisory",75000,"13068186",0.10,32,"181461389","existingbusiness","2026-08-24","2026-05-26","","",0,""),
 (41880106343,"University of Michigan - Cyber Mergers & Acquisitions",75000,"13068186",0.10,21,"117983497","newbusiness","2026-08-03","2025-08-12","2026-05-26","",1,""),
 (35681475343,"IU Health - LogicGate Implementation and Program Optimization",75000,"15636527",0.40,12,"181461389","existingbusiness","2026-07-31","2025-04-11","2026-02-04","",1,""),
 (55827762509,"Zoetis - Deepfake",75000,"13068186",0.10,13,"77029996","newbusiness","2026-05-01","2026-02-09","2026-06-12","2026-06-29",1,""),
 (58025336233,"McLaren Health - Merger and Acquisition",75000,"13068186",0.10,23,"181461389","newbusiness","2026-12-07","2026-03-16","2026-05-13","",1,""),
 (60689839013,"Curi Bio Pharma - vCISO",75000,"13068186",0.10,21,"117983497","newbusiness","2026-12-11","2026-05-28","2026-06-10","2026-06-16",1,""),
 (61024900688,"Curi Bio",70000,"15636527",0.40,43,"117983497","newbusiness","2026-06-22","2026-06-10","","2026-06-16",1,""),
 (52994272329,"Republic Airways - Application Security Program",70000,"13068186",0.10,14,"77029996","","2026-07-13","2026-01-05","2026-05-18","2026-06-26",0,""),
 (44611774556,"Kidde Global Solutions - GRC Program Assessment & Strategy",60000,"13068186",0.10,9,"117983497","newbusiness","2026-08-03","2025-09-26","2025-09-17","",1,""),
 (51831982088,"Vee Healthtek - GRC Program Support",60000,"15636527",0.40,None,"181461389","newbusiness","2026-07-31","2025-12-15","2026-03-23","2026-06-26",1,""),
 (55827642151,"UniqueMinds - Cyber Strategy + Basics",56000,"13068186",0.10,20,"77029996","existingbusiness","2026-07-31","2026-02-09","2026-05-14","2026-07-01",0,""),
 (56807538757,"BCBS Alabama - Deepfake Social Engineering",50000,"13068186",0.10,5,"181461389","newbusiness","","2026-02-22","2026-04-27","",1,"Christy proposed calendar options Feb 23. Follow up if meeting not yet locked with Josh McInnish."),
 (53014685074,"Republic Airways - RIM Maturity",50000,"13068186",0.10,20,"181461389","existingbusiness","2026-07-10","2026-01-05","2026-05-25","",0,""),
 (57553844999,"Elanco - GRC Support Workshops",50000,"decisionmakerboughtin",0.85,77,"117983497","existingbusiness","2026-06-22","2026-03-04","2026-06-11","2026-06-18",1,""),
 (58295578972,"Health First - TTX",50000,"13068186",0.10,29,"181461389","existingbusiness","2026-06-24","2026-03-26","","2026-06-18",1,""),
 (58295941498,"VitalCare - BCP TTX",45000,"1182680698",0.65,34,"181461389","existingbusiness","2026-06-26","2026-03-25","2026-06-09","2026-06-18",1,""),
 (51514546033,"Cummins - Awareness Creative Support",42500,"15636527",0.40,28,"77029996","existingbusiness","2026-07-17","2025-12-09","2026-06-09","2026-06-16",1,""),
 (60142318876,"Eli Lilly - Laura Viaches (extension)",41580,"1182680698",0.65,64,"77029996","newbusiness","2026-07-03","2026-05-11","2026-06-10","2026-06-17",0,""),
 (55653111975,"TGI - NIST Assessment",40000,"15636527",0.40,26,"181461389","existingbusiness","2026-07-10","2026-02-06","2026-05-04","",1,""),
 (58901978665,"Sallie Mae - AI M365 Assessment",31500,"decisionmakerboughtin",0.85,79,"77029996","existingbusiness","2026-06-19","2026-04-07","2026-06-11","2026-06-17",1,""),
 (55922621873,"NTN - M365 Config Assessment",25000,"1182680698",0.65,35,"181461389","existingbusiness","2026-06-30","2026-02-10","2026-06-12","",1,""),
 (60781496869,"Lilly Conductor one 6 month extension",25000,"1182680698",0.65,54,"77029996","existingbusiness","2026-06-29","2026-06-01","2026-06-11","2026-06-17",0,""),
 (44810909057,"First Internet Bank - Configuration Review",25000,"15636527",0.40,24,"181461389","newbusiness","2026-07-31","2025-09-29","2026-06-15","",1,""),
 (31930766686,"Valeo - AI Governance",20000,"13068186",0.40,19,"77029996","existingbusiness","2026-07-31","2025-01-13","2026-06-15","2026-06-22",1,""),
 (58761047919,"Lewis Wagner - Deposition T&M",4000,"15636527",0.40,17,"117983497","existingbusiness","2026-07-27","2026-04-03","2026-05-20","",1,""),
 (56646569021,"MISO - NIST Assessment + Strategy",None,"13068186",0.10,5,"181461389","existingbusiness","2026-08-28","2026-02-20","2026-03-31","2026-06-23",1,""),
 (46637473378,"Olio Health - vCISO",None,"13068186",0.10,15,"181461389","existingbusiness","2026-07-06","2025-10-21","2026-01-28","",1,""),
 (43743416158,"Telamon - Assessment, Strat, Roadmap",None,"13068186",0.10,None,"181461389","newbusiness","2026-07-10","2025-09-16","2026-02-10","",1,""),
 (58295754756,"VitalCare - InfoClass",None,"13068186",0.10,12,"181461389","existingbusiness","","2026-03-25","2026-04-23","2026-06-18",1,""),
 (35683755331,"Margaret Mary Health - Arctic Wolf MDR/MR",None,"13068186",0.10,13,"181461389","newbusiness","2026-06-26","2025-04-11","","",0,""),
 (42555970639,"Thermo Fisher - GRC / Office of the CISO",None,"13068186",0.10,None,"50024408","newbusiness","","2025-08-20","2026-01-23","2026-07-10",1,""),
]

def diso(s):
    return date.fromisoformat(s) if s else None

def days_since(s):
    d = diso(s)
    return (TODAY - d).days if d else None

HEADERS = [
    ("Deal Name", 34), ("Account", 20), ("Owner", 15), ("Stage", 15),
    ("Amount (USD)", 13), ("Win %", 8), ("Weighted (USD)", 14), ("Type", 9),
    ("Deal Score", 10), ("Close Date", 12), ("Close Status", 14),
    ("Days in Pipeline", 14), ("Last Activity", 12), ("Days Since Activity", 16),
    ("Next Activity", 12), ("Current Next Step (HubSpot)", 40), ("# Contacts", 10),
    ("HubSpot Link", 16),
    ("Aaron's Comments / Stuck?", 34), ("Next Step to Assign (task)", 38), ("Task Due Date", 14),
    ("Deal ID", 13), ("Owner ID", 12),
]
USER_COLS = {"Aaron's Comments / Stuck?", "Next Step to Assign (task)", "Task Due Date"}

wb = Workbook()
ws = wb.active
ws.title = "Active Deals"

hdr_fill = PatternFill("solid", fgColor="1F3864")
user_fill = PatternFill("solid", fgColor="FFF2CC")
user_hdr_fill = PatternFill("solid", fgColor="BF8F00")
stale_fill = PatternFill("solid", fgColor="FCE4D6")
hdr_font = Font(bold=True, color="FFFFFF", size=11)
thin = Side(style="thin", color="D9D9D9")
border = Border(left=thin, right=thin, top=thin, bottom=thin)

# header row
for c, (name, width) in enumerate(HEADERS, start=1):
    cell = ws.cell(row=1, column=c, value=name)
    cell.font = hdr_font
    cell.fill = user_hdr_fill if name in USER_COLS else hdr_fill
    cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
    cell.border = border
    ws.column_dimensions[get_column_letter(c)].width = width

rows = sorted(DEALS, key=lambda d: (d[2] is None, -(d[2] or 0)))
r = 2
for (did, name, amount, stage, prob, score, owner, dtype, close, created, last_act, next_act, contacts, nstep) in rows:
    weighted = round(amount * prob) if amount is not None else None
    dip = days_since(created)
    dsa = days_since(last_act)
    cd = diso(close)
    if cd is None:
        cstatus = "No date"
    elif cd < TODAY:
        cstatus = "OVERDUE"
    else:
        cstatus = f"{(cd - TODAY).days}d out"
    link = f"https://app.hubspot.com/contacts/8243349/record/0-3/{did}"
    account = name.split(" - ")[0] if " - " in name else name
    vals = [
        name, account, OWNERS.get(owner, owner), STAGES.get(stage, stage),
        amount, prob, weighted, DEALTYPE.get(dtype, dtype),
        score, cd, cstatus, dip, diso(last_act), dsa, diso(next_act),
        nstep, contacts, link, "", "", "", did, owner,
    ]
    stale = (dsa is not None and dsa > 45) or cstatus == "OVERDUE"
    for c, v in enumerate(vals, start=1):
        cell = ws.cell(row=r, column=c, value=v)
        cell.border = border
        cell.alignment = Alignment(vertical="top", wrap_text=(c in (1, 16, 19, 20)))
        hname = HEADERS[c-1][0]
        if hname in USER_COLS:
            cell.fill = user_fill
        elif stale and hname in ("Last Activity", "Days Since Activity", "Close Status"):
            cell.fill = stale_fill
    # formats
    ws.cell(row=r, column=5).number_format = '#,##0'
    ws.cell(row=r, column=7).number_format = '#,##0'
    ws.cell(row=r, column=6).number_format = '0%'
    for col in (10, 13, 15):
        ws.cell(row=r, column=col).number_format = 'yyyy-mm-dd'
    ws.cell(row=r, column=18).hyperlink = link
    ws.cell(row=r, column=18).value = "Open deal"
    ws.cell(row=r, column=18).font = Font(color="0563C1", underline="single")
    r += 1

# totals row
tr = r
ws.cell(row=tr, column=1, value="TOTAL / 57 active deals").font = Font(bold=True)
total_amt = sum(d[2] for d in DEALS if d[2] is not None)
total_wtd = sum(round(d[2]*d[4]) for d in DEALS if d[2] is not None)
tc = ws.cell(row=tr, column=5, value=total_amt); tc.number_format = '#,##0'; tc.font = Font(bold=True)
tw = ws.cell(row=tr, column=7, value=total_wtd); tw.number_format = '#,##0'; tw.font = Font(bold=True)
for c in range(1, len(HEADERS)+1):
    ws.cell(row=tr, column=c).fill = PatternFill("solid", fgColor="D9E1F2")

ws.freeze_panes = "B2"
ws.auto_filter.ref = f"A1:{get_column_letter(len(HEADERS))}{r-1}"

# Notes / legend sheet
ws2 = wb.create_sheet("How to use")
notes = [
    ("Active Deals Pipeline — snapshot 2026-06-15", True),
    ("", False),
    ("Source: HubSpot 'Sales Pipeline'. Includes every deal NOT in Closed-Won or Closed-Lost.", False),
    ("57 active deals.", False),
    ("", False),
    ("Yellow columns are for you to fill in:", True),
    ("  • Aaron's Comments / Stuck?  — note deals that are stuck or need director attention.", False),
    ("  • Next Step to Assign (task) — the action you want logged as a HubSpot task for the deal owner.", False),
    ("  • Task Due Date — optional due date (YYYY-MM-DD) for that task.", False),
    ("", False),
    ("When you're done, send the file back and I'll create a HubSpot task on each deal", False),
    ("you commented on, assigned to that deal's owner, with your next step.", False),
    ("", False),
    ("Orange-shaded cells flag potential 'stuck' signals: close date is overdue, or no", False),
    ("logged activity in 45+ days. Use as a starting point, not gospel.", False),
    ("", False),
    ("Win % = HubSpot deal-stage probability. Weighted = Amount x Win %.", False),
    ("Deal Score = HubSpot AI deal health score (0-100).", False),
]
for i, (t, bold) in enumerate(notes, start=1):
    cc = ws2.cell(row=i, column=1, value=t)
    if bold:
        cc.font = Font(bold=True, size=12 if i == 1 else 11)
ws2.column_dimensions["A"].width = 100

out = "Active_Deals_Pipeline_2026-06-15.xlsx"
wb.save(out)
print("wrote", out, "rows:", len(DEALS), "total amount:", total_amt, "weighted:", total_wtd)
