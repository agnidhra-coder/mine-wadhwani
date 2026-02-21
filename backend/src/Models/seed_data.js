const questions = [
  /* ===============================
   PART 1 – GENERAL CONDITIONS OF TITLE
  ================================ */

  // 1 Notice to landholders
  {
    questionCode: "1.1",
    maintopic: "General Conditions of Title",
    subtopic: "Notice to Landholders",
    questionText:
      "Was the authorisation granted or renewed within the audit period?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "1.2",
    maintopic: "General Conditions of Title",
    subtopic: "Notice to Landholders",
    questionText:
      "Were there more than 10 landholders within the authorisation area at the time of grant or renewal of your authorisation?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "1.3",
    maintopic: "General Conditions of Title",
    subtopic: "Notice to Landholders",
    questionText:
      "Has notification been served on each landholder, either by letter or newspaper advertisement as required?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 2 – REHABILITATION
  ================================ */

  // 2.1 Rehabilitation risk assessment
  {
    questionCode: "2.1.1",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Risk Assessment",
    questionText:
      "Have you undertaken a rehabilitation risk assessment to evaluate the range of potential threats and opportunities associated with rehabilitating your site to a condition that can support the intended final land use(s)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.1.2",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Risk Assessment",
    questionText:
      "Do you regularly review the rehabilitation risk assessment and update it as required to reflect changes in activities or risks to rehabilitation outcomes?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.1.3",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Risk Assessment",
    questionText:
      "Is your risk assessment (and any review) documented and maintained?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.1.4",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Risk Assessment",
    questionText:
      "Have you developed specific, measurable, achievable, realistic and time-bound rehabilitation objectives and completion criteria for activities associated with the mining operation? Have they been developed in consultation with relevant landholders?",
    answer: "",
    comment: "",
  },

  // 2.2 Rehabilitation monitoring
  {
    questionCode: "2.2.1",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Monitoring",
    questionText:
      "Have you developed adequate rehabilitation monitoring and management programs for the mining operations?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.2.2",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Monitoring",
    questionText:
      "Do those programs consider the scope, frequency, numbering of monitoring locations and use of analogue sites?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.2.3",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Monitoring",
    questionText:
      "Do you have evidence to indicate that your rehabilitation monitoring programs are being effectively implemented on-site?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.2.4",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Monitoring",
    questionText:
      "Do you use the results of the rehabilitation monitoring programs to assess performance against the rehabilitation objectives and criteria?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.2.5",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Monitoring",
    questionText:
      "Do you modify your rehabilitation management programs when monitoring results indicate that rehabilitation criteria are not being achieved?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.2.6",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Monitoring",
    questionText:
      "Where rehabilitation monitoring shows that results are not meeting rehabilitation criteria, are corrective actions identified, implemented, monitored and closed out?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.2.7",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Monitoring",
    questionText:
      "Have you developed and implemented rehabilitation care and maintenance programs to ensure that rehabilitation will meet the final land use objectives identified for the site?",
    answer: "",
    comment: "",
  },

  // 2.3 Rehabilitation records
  {
    questionCode: "2.3.1",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Records",
    questionText:
      "Are you maintaining records to demonstrate what rehabilitation works have been undertaken?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.3.2",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Records",
    questionText:
      "Do you take and maintain photographs of your rehabilitation activities?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.3.3",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Records",
    questionText:
      "Do you record the actual methodologies used to rehabilitate the site being maintained (for example, species utilised, fertiliser rate, details of ripping and scarifying, timing of sowing, sowing rates, seedling planting density, origin of seed, rainfall, and other)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.3.4",
    maintopic: "Rehabilitation",
    subtopic: "Rehabilitation Records",
    questionText:
      "Do you capture and maintain records of care and maintenance activities undertaken on rehabilitation areas?",
    answer: "",
    comment: "",
  },

  // 2.4 Current rehabilitation status
  {
    questionCode: "2.4.1",
    maintopic: "Rehabilitation",
    subtopic: "Current Rehabilitation Status",
    questionText:
      "Do you have evidence to demonstrate that rehabilitation is being undertaken progressively?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.4.2",
    maintopic: "Rehabilitation",
    subtopic: "Current Rehabilitation Status",
    questionText:
      "Have you reviewed your rehabilitation progress and is it on track to comply with the final landform and land use objectives?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "2.4.3",
    maintopic: "Rehabilitation",
    subtopic: "Current Rehabilitation Status",
    questionText:
      "Are there any areas of incomplete rehabilitation on your site or any areas that, if left unmanaged, are likely to result in a delay in achieving the rehabilitation obligations for the site?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 3 – MINING OPERATIONS PLAN
  ================================ */

  {
    questionCode: "3.1",
    maintopic: "Mining Operations Plan",
    subtopic: "Plan Compliance",
    questionText:
      "Have you prepared and submitted a mining operations plan for your mining operation?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "3.2",
    maintopic: "Mining Operations Plan",
    subtopic: "Plan Compliance",
    questionText:
      "Has the mining operations plan been approved by the Regulator?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "3.3",
    maintopic: "Mining Operations Plan",
    subtopic: "Plan Compliance",
    questionText:
      "Does your mining operations plan identify the approved post-mining land use and set out a detailed rehabilitation strategy to achieve that land use?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "3.4",
    maintopic: "Mining Operations Plan",
    subtopic: "Plan Compliance",
    questionText:
      "Based on your rehabilitation risk assessment, have you identified and implemented suitable controls to manage the risks identified?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "3.5",
    maintopic: "Mining Operations Plan",
    subtopic: "Plan Compliance",
    questionText:
      "Do you have processes to check that those controls have been implemented on the site and are effective in managing the risk?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "3.6",
    maintopic: "Mining Operations Plan",
    subtopic: "Plan Compliance",
    questionText:
      "Do you have systems and processes in place to monitor compliance against the mining operations plan requirements?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "3.7",
    maintopic: "Mining Operations Plan",
    subtopic: "Plan Compliance",
    questionText:
      "If your MOP is due to expire, have you ensured that you have prepared a new MOP and submitted it for approval before the expiry of the current MOP?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 4 – ANNUAL ENVIRONMENTAL MANAGEMENT REPORT OR ANNUAL REVIEW
  ================================ */

  {
    questionCode: "4.1",
    maintopic: "Annual Environmental Management Report",
    subtopic: "Reporting",
    questionText:
      "Do you have a system in place to remind you when reports are due?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "4.2",
    maintopic: "Annual Environmental Management Report",
    subtopic: "Reporting",
    questionText:
      "Have you prepared and submitted rehabilitation reports for your mining operations by the due dates?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "4.3",
    maintopic: "Annual Environmental Management Report",
    subtopic: "Reporting",
    questionText:
      "Does each rehabilitation report provide a detailed review of the progress of your rehabilitation activities?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "4.4",
    maintopic: "Annual Environmental Management Report",
    subtopic: "Reporting",
    questionText:
      "Are your rehabilitation reports submitted annually on the grant anniversary date (or other agreed date)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "4.5",
    maintopic: "Annual Environmental Management Report",
    subtopic: "Reporting",
    questionText:
      "If you have not been able to submit reports within the required timeframes, have you sought and been granted extensions of time to lodge reports?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "4.6",
    maintopic: "Annual Environmental Management Report",
    subtopic: "Reporting",
    questionText:
      "Have you been granted any exemptions to prepare and lodge reports about your mining operations?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 5 – NON-COMPLIANCE REPORTING
  ================================ */

  {
    questionCode: "5.1",
    maintopic: "Non-Compliance Reporting",
    subtopic: "Compliance",
    questionText:
      "Are there systems and processes in place to detect and action non-compliances?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "5.2",
    maintopic: "Non-Compliance Reporting",
    subtopic: "Compliance",
    questionText:
      "Have you detected any non-compliances during the audit scope period?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "5.3",
    maintopic: "Non-Compliance Reporting",
    subtopic: "Compliance",
    questionText:
      "If yes, were those non-compliances notified to the Regulator?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "5.4",
    maintopic: "Non-Compliance Reporting",
    subtopic: "Compliance",
    questionText: "Was that notification done within the seven day timeframe?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "5.5",
    maintopic: "Non-Compliance Reporting",
    subtopic: "Compliance",
    questionText:
      "Have you taken actions to prevent any recurrence, or to mitigate the effects, of that non-compliance?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 6 – ENVIRONMENTAL INCIDENT REPORTING
  ================================ */

  {
    questionCode: "6.1",
    maintopic: "Environmental Incident Reporting",
    subtopic: "Incident Reporting",
    questionText:
      "Do you have systems and processes in place to detect and action environmental incidents?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "6.2",
    maintopic: "Environmental Incident Reporting",
    subtopic: "Incident Reporting",
    questionText:
      "Have any environmental incidents occurred during the audit scope period?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "6.3",
    maintopic: "Environmental Incident Reporting",
    subtopic: "Incident Reporting",
    questionText:
      "If yes, have you reported those incidents to EPA or other agencies?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "6.4",
    maintopic: "Environmental Incident Reporting",
    subtopic: "Incident Reporting",
    questionText: "Have you also provided reports to the Regulator?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "6.5",
    maintopic: "Environmental Incident Reporting",
    subtopic: "Incident Reporting",
    questionText:
      "Were those reports submitted to the Regulator within the seven day timeframe?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 7 – RESOURCE RECOVERY
  ================================ */

  {
    questionCode: "7.1",
    maintopic: "Resource Recovery",
    subtopic: "Resource Recovery",
    questionText: "Are you actively working your mining lease(s)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "7.2",
    maintopic: "Resource Recovery",
    subtopic: "Resource Recovery",
    questionText:
      "Do you submit production quantities to Division of Resources and Geosciences?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "7.3",
    maintopic: "Resource Recovery",
    subtopic: "Resource Recovery",
    questionText:
      "Has the Geological Survey of NSW raised any concerns with you about recovery of resources? Have these concerns been acted upon?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 8 – SECURITY
  ================================ */

  {
    questionCode: "8.1",
    maintopic: "Security",
    subtopic: "Security Deposit",
    questionText: "Have you paid the required security amount?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "8.2",
    maintopic: "Security",
    subtopic: "Security Deposit",
    questionText:
      "Have you provided a rehabilitation cost estimate at required intervals or triggers (for example, at renewal, when submitting the annual environmental management report or when submitting the mining operations plan)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "8.3",
    maintopic: "Security",
    subtopic: "Security Deposit",
    questionText:
      "Was your rehabilitation cost estimate prepared using the Regulator's rehabilitation cost estimation tool?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 9 – COOPERATION AGREEMENT
  ================================ */

  {
    questionCode: "9.1",
    maintopic: "Cooperation Agreement",
    subtopic: "Overlapping Titles",
    questionText:
      "Are there any other mining or exploration titles that overlap with your title(s)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.2",
    maintopic: "Cooperation Agreement",
    subtopic: "Overlapping Titles",
    questionText:
      "If there are overlapping titles, have you attempted to negotiate a co-operation agreement with the overlapping titleholder?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.i",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Access arrangements?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.ii",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Operational interaction procedures?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.iii",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Dispute resolution?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.iv",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Information exchange?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.v",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Drillhole location?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.vi",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Timing of drilling?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.vii",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Potential resource extraction conflicts?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "9.3.viii",
    maintopic: "Cooperation Agreement",
    subtopic: "Cooperation Agreement Contents",
    questionText:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Rehabilitation issues?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 10 – EXPLORATION REPORTING
  ================================ */

  {
    questionCode: "10.1",
    maintopic: "Exploration Reporting",
    subtopic: "Reporting",
    questionText:
      "Do you have systems and processes in place to track reporting dates?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "10.2",
    maintopic: "Exploration Reporting",
    subtopic: "Reporting",
    questionText:
      "Have you submitted annual exploration reports in accordance with the guideline?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "10.3",
    maintopic: "Exploration Reporting",
    subtopic: "Reporting",
    questionText:
      "Do you submit your reports within the 30 day timeframe after grant anniversary date?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "10.4",
    maintopic: "Exploration Reporting",
    subtopic: "Reporting",
    questionText:
      "If you have been unable to submit your reports within the required timeframes, have you applied for and been granted extensions of time to lodge reports?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "10.5",
    maintopic: "Exploration Reporting",
    subtopic: "Reporting",
    questionText:
      "Have any exemptions been granted to prepare and lodge reports about the titles?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "10.6",
    maintopic: "Exploration Reporting",
    subtopic: "Reporting",
    questionText:
      "Have you prepared your exploration reports in accordance with the guideline 'Exploration Reporting: A guide for reporting on exploration and prospecting in NSW' and relevant DRG templates?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 11 – EXTRACTION PLAN (COAL TITLES ONLY)
  ================================ */

  {
    questionCode: "11.1",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Extraction Plan",
    questionText: "Are you undertaking underground mining?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.2",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Extraction Plan",
    questionText:
      "Have you prepared and had approved an extraction plan for the underground operations?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.3",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Extraction Plan",
    questionText:
      "Does your extraction plan identify the risks associated with subsidence resulting from mining operations?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.4",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Extraction Plan",
    questionText: "Have you identified appropriate risk controls?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.5",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Extraction Plan",
    questionText: "Have those risk controls been implemented?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.6",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Extraction Plan",
    questionText:
      "Do you have systems and processes for monitoring the implementation of the risk controls?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.7",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Extraction Plan",
    questionText:
      "Have you undertaken any assessment of the effectiveness of the risk controls?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.8.i",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Regulator Notifications",
    questionText:
      "Have you made any notifications to the Regulator for any: Incident caused by subsidence that has a potential to expose any person to health and safety risks?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.8.ii",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Regulator Notifications",
    questionText:
      "Have you made any notifications to the Regulator for any: Significant deviation from the predicted nature, magnitude, distribution, timing and duration of subsidence effects, and of the potential impacts and consequences of those deviations on built features and the health and safety of any person?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.8.iii",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Regulator Notifications",
    questionText:
      "Have you made any notifications to the Regulator for any: Significant failure or malfunction of a monitoring device or risk control measure set out in the approved extraction plan addressing built features, public safety or subsidence monitoring?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.9",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Regulator Notifications",
    questionText:
      "If yes to any part of question 8, were the notifications made within the 48 hour timeframe specified?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "11.10",
    maintopic: "Extraction Plan (Coal Titles Only)",
    subtopic: "Regulator Notifications",
    questionText:
      "Where incidents, significant deviations or failures have occurred, were appropriate corrective and preventive actions identified and implemented?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 12 – MINING OR PROSPECTING WITHOUT AUTHORISATION
  ================================ */

  {
    questionCode: "12.1",
    maintopic: "Mining or Prospecting Without Authorisation",
    subtopic: "Authorisation Compliance",
    questionText:
      "Are you undertaking your mining operations in accordance with the conditions of your authorisation(s)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "12.2",
    maintopic: "Mining or Prospecting Without Authorisation",
    subtopic: "Authorisation Compliance",
    questionText:
      "Are you undertaking all mining operations and ancillary mining activities within your lease boundaries?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "12.3",
    maintopic: "Mining or Prospecting Without Authorisation",
    subtopic: "Authorisation Compliance",
    questionText:
      "If not, does the exemption for ancillary mining activities apply?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 13 – APPLICATIONS FOR RENEWAL OF MINING LEASE
  ================================ */

  {
    questionCode: "13.1",
    maintopic: "Applications for Renewal of Mining Lease",
    subtopic: "Renewal",
    questionText:
      "Have you renewed your mining lease/s during the audit scope period?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "13.2",
    maintopic: "Applications for Renewal of Mining Lease",
    subtopic: "Renewal",
    questionText:
      "Was the renewal application made on the standard departmental form?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "13.3",
    maintopic: "Applications for Renewal of Mining Lease",
    subtopic: "Renewal",
    questionText:
      "Was a renewal justification statement included with the application?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "13.4",
    maintopic: "Applications for Renewal of Mining Lease",
    subtopic: "Renewal",
    questionText:
      "Was a rehabilitation cost estimate provided with the application?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "13.5",
    maintopic: "Applications for Renewal of Mining Lease",
    subtopic: "Renewal",
    questionText:
      "Was a statement of corporate compliance, environmental performance history and financial capability provided with the application?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "13.6",
    maintopic: "Applications for Renewal of Mining Lease",
    subtopic: "Renewal",
    questionText:
      "Was a copy of the development consent included with the application?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 14 – SECTION 163C REPORTS
  ================================ */

  {
    questionCode: "14.1",
    maintopic: "Section 163C Reports",
    subtopic: "Exploration Reports",
    questionText:
      "Have you prepared and submitted annual reports for your exploration licence?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "14.2",
    maintopic: "Section 163C Reports",
    subtopic: "Exploration Reports",
    questionText:
      "If you have relinquished parts of your licence area, have you prepared and submitted partial relinquishment reports?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "14.3",
    maintopic: "Section 163C Reports",
    subtopic: "Exploration Reports",
    questionText:
      "If you are cancelling or not renewing your exploration licence, have you prepared and submitted a final report?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "14.4",
    maintopic: "Section 163C Reports",
    subtopic: "Exploration Reports",
    questionText:
      "Have you submitted all required maps, plans and data in the required formats?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 15 – SECTION 163D RECORD KEEPING
  ================================ */

  {
    questionCode: "15.1",
    maintopic: "Section 163D Record Keeping",
    subtopic: "Record Keeping",
    questionText:
      "Do you have systems and processes in place to capture and maintain required records?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "15.2",
    maintopic: "Section 163D Record Keeping",
    subtopic: "Record Keeping",
    questionText: "Are your records well-organised and stored properly?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "15.3",
    maintopic: "Section 163D Record Keeping",
    subtopic: "Record Keeping",
    questionText: "Are your all records readily retrievable?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "15.4",
    maintopic: "Section 163D Record Keeping",
    subtopic: "Record Keeping",
    questionText:
      "Have you provided all data to the department in accordance with the exploration reporting guideline requirements?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 16 – SECTION 282 LIABILITY TO PAY ROYALTY
  ================================ */

  {
    questionCode: "16.1",
    maintopic: "Section 282 Liability to Pay Royalty",
    subtopic: "Royalty",
    questionText:
      "Do you have systems and processes in place to remind you when your royalty returns and payments are due?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "16.2",
    maintopic: "Section 282 Liability to Pay Royalty",
    subtopic: "Royalty",
    questionText: "Have you provided royalty returns as required?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "16.3",
    maintopic: "Section 282 Liability to Pay Royalty",
    subtopic: "Royalty",
    questionText: "Have your royalty payments been made by the due dates?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 17 – ANNUAL RENTAL FEE AND ANNUAL ADMINISTRATIVE LEVY
  ================================ */

  {
    questionCode: "17.1",
    maintopic: "Annual Rental Fee and Annual Administrative Levy",
    subtopic: "Fees and Levies",
    questionText:
      "Do you have systems and processes in place to remind you when your rent and levy payments are due?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "17.2",
    maintopic: "Annual Rental Fee and Annual Administrative Levy",
    subtopic: "Fees and Levies",
    questionText: "Have you paid your rents and levies by the due dates?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 18 – SUSPENSION OF MINING OPERATIONS
  ================================ */

  {
    questionCode: "18.1",
    maintopic: "Suspension of Mining Operations",
    subtopic: "Suspension",
    questionText: "Have you suspended your mining operations?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "18.2",
    maintopic: "Suspension of Mining Operations",
    subtopic: "Suspension",
    questionText:
      "If yes, was approval applied for and granted for the suspension of operations?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "18.3",
    maintopic: "Suspension of Mining Operations",
    subtopic: "Suspension",
    questionText:
      "Were any conditions attached to the approval to suspend operations?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "18.4",
    maintopic: "Suspension of Mining Operations",
    subtopic: "Suspension",
    questionText: "Have you complied with those conditions?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 19 – COMPLIANCE MANAGEMENT
  ================================ */

  {
    questionCode: "19.1",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText: "Have you identified your compliance requirements?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "19.2",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText:
      "Have you undertaken any analysis of your compliance risks in relation to possible causes and sources of non-compliance?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "19.3",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText:
      "Are there any systems in place to monitor and track compliance requirements?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "19.4",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText:
      "Is there a system in place to manage non-compliances that are identified?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "19.5",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText:
      "Is there a system in place to identify and manage change (for example, a new hardstand facility might require a MOP amendment)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "19.6",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText:
      "Are changes to compliance requirements and controls communicated to operational personnel (for example, is there a toolbox talk process or similar)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "19.7",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText:
      "Are there effective mechanisms in place for internal communication?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "19.8",
    maintopic: "Compliance Management",
    subtopic: "Compliance Management",
    questionText:
      "Do you evaluate your compliance with a view to continual improvement of performance?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 20 – RISK IDENTIFICATION AND ASSESSMENT
  ================================ */

  {
    questionCode: "20.1",
    maintopic: "Risk Identification and Assessment",
    subtopic: "Risk Assessment",
    questionText:
      "Have you undertaken any process mapping and risk assessment to identify key issues for your operation?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "20.2",
    maintopic: "Risk Identification and Assessment",
    subtopic: "Risk Assessment",
    questionText:
      "Where key issues are identified, have appropriate controls been put in place to manage those risks?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "20.3",
    maintopic: "Risk Identification and Assessment",
    subtopic: "Risk Assessment",
    questionText:
      "Does the risk identification and assessment address operational and environmental risks as well as safety risks?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "20.4",
    maintopic: "Risk Identification and Assessment",
    subtopic: "Risk Assessment",
    questionText:
      "Is the risk assessment regularly reviewed and updated as necessary?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 21 – MANAGING YOUR CONTRACTORS
  ================================ */

  {
    questionCode: "21.1",
    maintopic: "Managing Your Contractors",
    subtopic: "Contractor Management",
    questionText:
      "Do you use any subcontracted services (for example, drillers, trucking, or other services)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "21.2",
    maintopic: "Managing Your Contractors",
    subtopic: "Contractor Management",
    questionText:
      "Do you communicate any relevant key issues and controls to the subcontractor (for example, performance specifications, induction processes, or other issues and controls)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "21.3",
    maintopic: "Managing Your Contractors",
    subtopic: "Contractor Management",
    questionText:
      "Do you monitor the activities of the subcontractor (for example, surveillance, audits, inspection or through other means)?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "21.4",
    maintopic: "Managing Your Contractors",
    subtopic: "Contractor Management",
    questionText:
      "Do you obtain copies of key records generated by subcontractors to verify compliance with your obligations as a title holder (for example, borehole sealing records, drilling records, or other records)?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 22 – INSPECTING, MONITORING AND EVALUATING
  ================================ */

  {
    questionCode: "22.1",
    maintopic: "Inspecting, Monitoring and Evaluating",
    subtopic: "Monitoring and Evaluation",
    questionText:
      "Do you have systems in place for the inspection, monitoring, and evaluation of key risk controls?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "22.2",
    maintopic: "Inspecting, Monitoring and Evaluating",
    subtopic: "Monitoring and Evaluation",
    questionText: "Are inspections documented?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "22.3",
    maintopic: "Inspecting, Monitoring and Evaluating",
    subtopic: "Monitoring and Evaluation",
    questionText:
      "Is there a closeout loop to ensure any non-compliances or defects identified can be tracked, addressed and closed out?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "22.4",
    maintopic: "Inspecting, Monitoring and Evaluating",
    subtopic: "Monitoring and Evaluation",
    questionText:
      "Is there periodic review and evaluation of monitoring and inspection results to verify controls are effective, or identify any trends in particular issues?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "22.5",
    maintopic: "Inspecting, Monitoring and Evaluating",
    subtopic: "Monitoring and Evaluation",
    questionText:
      "Where incidents occur, are there adequate processes in place for reporting these?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "22.6",
    maintopic: "Inspecting, Monitoring and Evaluating",
    subtopic: "Monitoring and Evaluation",
    questionText:
      "Are there any internal reporting systems, and is information from these systems and processes used in the decision-making process?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "22.7",
    maintopic: "Inspecting, Monitoring and Evaluating",
    subtopic: "Monitoring and Evaluation",
    questionText: "Is there any form of management review?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 23 – TRAINING AND COMPETENCY
  ================================ */

  {
    questionCode: "23.1",
    maintopic: "Training and Competency",
    subtopic: "Training",
    questionText:
      "Have you identified core competencies required for positions?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "23.2",
    maintopic: "Training and Competency",
    subtopic: "Training",
    questionText:
      "Is there a skills matrix or other similar tool used to identify any training gaps?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "23.3",
    maintopic: "Training and Competency",
    subtopic: "Training",
    questionText: "Are training records documented?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "23.4",
    maintopic: "Training and Competency",
    subtopic: "Training",
    questionText:
      "Is there a system in place to monitor training expiry dates and program any required re-training?",
    answer: "",
    comment: "",
  },
  {
    questionCode: "23.5",
    maintopic: "Training and Competency",
    subtopic: "Training",
    questionText:
      "Is there an induction program and does it address key operational, environmental, and safety risks?",
    answer: "",
    comment: "",
  },
];

export default questions;
