const questions = [
  /* ===============================
   PART 1 – GENERAL CONDITIONS OF TITLE
  ================================ */

  // 1 Notice to landholders
  {
    question_code: "1.1",
    main_topic: "General Conditions of Title",
    sub_topic: "Notice to Landholders",
    question_text:
      "Was the authorisation granted or renewed within the audit period?",
    answer: "",
    comment: "",
  },
  {
    question_code: "1.2",
    main_topic: "General Conditions of Title",
    sub_topic: "Notice to Landholders",
    question_text:
      "Were there more than 10 landholders within the authorisation area at the time of grant or renewal of your authorisation?",
    answer: "",
    comment: "",
  },
  {
    question_code: "1.3",
    main_topic: "General Conditions of Title",
    sub_topic: "Notice to Landholders",
    question_text:
      "Has notification been served on each landholder, either by letter or newspaper advertisement as required?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 2 – REHABILITATION
  ================================ */

  // 2.1 Rehabilitation risk assessment
  {
    question_code: "2.1.1",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Risk Assessment",
    question_text:
      "Have you undertaken a rehabilitation risk assessment to evaluate the range of potential threats and opportunities associated with rehabilitating your site to a condition that can support the intended final land use(s)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.1.2",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Risk Assessment",
    question_text:
      "Do you regularly review the rehabilitation risk assessment and update it as required to reflect changes in activities or risks to rehabilitation outcomes?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.1.3",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Risk Assessment",
    question_text:
      "Is your risk assessment (and any review) documented and maintained?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.1.4",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Risk Assessment",
    question_text:
      "Have you developed specific, measurable, achievable, realistic and time-bound rehabilitation objectives and completion criteria for activities associated with the mining operation? Have they been developed in consultation with relevant landholders?",
    answer: "",
    comment: "",
  },

  // 2.2 Rehabilitation monitoring
  {
    question_code: "2.2.1",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Monitoring",
    question_text:
      "Have you developed adequate rehabilitation monitoring and management programs for the mining operations?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.2.2",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Monitoring",
    question_text:
      "Do those programs consider the scope, frequency, numbering of monitoring locations and use of analogue sites?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.2.3",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Monitoring",
    question_text:
      "Do you have evidence to indicate that your rehabilitation monitoring programs are being effectively implemented on-site?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.2.4",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Monitoring",
    question_text:
      "Do you use the results of the rehabilitation monitoring programs to assess performance against the rehabilitation objectives and criteria?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.2.5",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Monitoring",
    question_text:
      "Do you modify your rehabilitation management programs when monitoring results indicate that rehabilitation criteria are not being achieved?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.2.6",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Monitoring",
    question_text:
      "Where rehabilitation monitoring shows that results are not meeting rehabilitation criteria, are corrective actions identified, implemented, monitored and closed out?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.2.7",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Monitoring",
    question_text:
      "Have you developed and implemented rehabilitation care and maintenance programs to ensure that rehabilitation will meet the final land use objectives identified for the site?",
    answer: "",
    comment: "",
  },

  // 2.3 Rehabilitation records
  {
    question_code: "2.3.1",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Records",
    question_text:
      "Are you maintaining records to demonstrate what rehabilitation works have been undertaken?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.3.2",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Records",
    question_text:
      "Do you take and maintain photographs of your rehabilitation activities?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.3.3",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Records",
    question_text:
      "Do you record the actual methodologies used to rehabilitate the site being maintained (for example, species utilised, fertiliser rate, details of ripping and scarifying, timing of sowing, sowing rates, seedling planting density, origin of seed, rainfall, and other)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.3.4",
    main_topic: "Rehabilitation",
    sub_topic: "Rehabilitation Records",
    question_text:
      "Do you capture and maintain records of care and maintenance activities undertaken on rehabilitation areas?",
    answer: "",
    comment: "",
  },

  // 2.4 Current rehabilitation status
  {
    question_code: "2.4.1",
    main_topic: "Rehabilitation",
    sub_topic: "Current Rehabilitation Status",
    question_text:
      "Do you have evidence to demonstrate that rehabilitation is being undertaken progressively?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.4.2",
    main_topic: "Rehabilitation",
    sub_topic: "Current Rehabilitation Status",
    question_text:
      "Have you reviewed your rehabilitation progress and is it on track to comply with the final landform and land use objectives?",
    answer: "",
    comment: "",
  },
  {
    question_code: "2.4.3",
    main_topic: "Rehabilitation",
    sub_topic: "Current Rehabilitation Status",
    question_text:
      "Are there any areas of incomplete rehabilitation on your site or any areas that, if left unmanaged, are likely to result in a delay in achieving the rehabilitation obligations for the site?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 3 – MINING OPERATIONS PLAN
  ================================ */

  {
    question_code: "3.1",
    main_topic: "Mining Operations Plan",
    sub_topic: "Plan Compliance",
    question_text:
      "Have you prepared and submitted a mining operations plan for your mining operation?",
    answer: "",
    comment: "",
  },
  {
    question_code: "3.2",
    main_topic: "Mining Operations Plan",
    sub_topic: "Plan Compliance",
    question_text:
      "Has the mining operations plan been approved by the Regulator?",
    answer: "",
    comment: "",
  },
  {
    question_code: "3.3",
    main_topic: "Mining Operations Plan",
    sub_topic: "Plan Compliance",
    question_text:
      "Does your mining operations plan identify the approved post-mining land use and set out a detailed rehabilitation strategy to achieve that land use?",
    answer: "",
    comment: "",
  },
  {
    question_code: "3.4",
    main_topic: "Mining Operations Plan",
    sub_topic: "Plan Compliance",
    question_text:
      "Based on your rehabilitation risk assessment, have you identified and implemented suitable controls to manage the risks identified?",
    answer: "",
    comment: "",
  },
  {
    question_code: "3.5",
    main_topic: "Mining Operations Plan",
    sub_topic: "Plan Compliance",
    question_text:
      "Do you have processes to check that those controls have been implemented on the site and are effective in managing the risk?",
    answer: "",
    comment: "",
  },
  {
    question_code: "3.6",
    main_topic: "Mining Operations Plan",
    sub_topic: "Plan Compliance",
    question_text:
      "Do you have systems and processes in place to monitor compliance against the mining operations plan requirements?",
    answer: "",
    comment: "",
  },
  {
    question_code: "3.7",
    main_topic: "Mining Operations Plan",
    sub_topic: "Plan Compliance",
    question_text:
      "If your MOP is due to expire, have you ensured that you have prepared a new MOP and submitted it for approval before the expiry of the current MOP?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 4 – ANNUAL ENVIRONMENTAL MANAGEMENT REPORT OR ANNUAL REVIEW
  ================================ */

  {
    question_code: "4.1",
    main_topic: "Annual Environmental Management Report",
    sub_topic: "Reporting",
    question_text:
      "Do you have a system in place to remind you when reports are due?",
    answer: "",
    comment: "",
  },
  {
    question_code: "4.2",
    main_topic: "Annual Environmental Management Report",
    sub_topic: "Reporting",
    question_text:
      "Have you prepared and submitted rehabilitation reports for your mining operations by the due dates?",
    answer: "",
    comment: "",
  },
  {
    question_code: "4.3",
    main_topic: "Annual Environmental Management Report",
    sub_topic: "Reporting",
    question_text:
      "Does each rehabilitation report provide a detailed review of the progress of your rehabilitation activities?",
    answer: "",
    comment: "",
  },
  {
    question_code: "4.4",
    main_topic: "Annual Environmental Management Report",
    sub_topic: "Reporting",
    question_text:
      "Are your rehabilitation reports submitted annually on the grant anniversary date (or other agreed date)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "4.5",
    main_topic: "Annual Environmental Management Report",
    sub_topic: "Reporting",
    question_text:
      "If you have not been able to submit reports within the required timeframes, have you sought and been granted extensions of time to lodge reports?",
    answer: "",
    comment: "",
  },
  {
    question_code: "4.6",
    main_topic: "Annual Environmental Management Report",
    sub_topic: "Reporting",
    question_text:
      "Have you been granted any exemptions to prepare and lodge reports about your mining operations?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 5 – NON-COMPLIANCE REPORTING
  ================================ */

  {
    question_code: "5.1",
    main_topic: "Non-Compliance Reporting",
    sub_topic: "Compliance",
    question_text:
      "Are there systems and processes in place to detect and action non-compliances?",
    answer: "",
    comment: "",
  },
  {
    question_code: "5.2",
    main_topic: "Non-Compliance Reporting",
    sub_topic: "Compliance",
    question_text:
      "Have you detected any non-compliances during the audit scope period?",
    answer: "",
    comment: "",
  },
  {
    question_code: "5.3",
    main_topic: "Non-Compliance Reporting",
    sub_topic: "Compliance",
    question_text:
      "If yes, were those non-compliances notified to the Regulator?",
    answer: "",
    comment: "",
  },
  {
    question_code: "5.4",
    main_topic: "Non-Compliance Reporting",
    sub_topic: "Compliance",
    question_text: "Was that notification done within the seven day timeframe?",
    answer: "",
    comment: "",
  },
  {
    question_code: "5.5",
    main_topic: "Non-Compliance Reporting",
    sub_topic: "Compliance",
    question_text:
      "Have you taken actions to prevent any recurrence, or to mitigate the effects, of that non-compliance?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 6 – ENVIRONMENTAL INCIDENT REPORTING
  ================================ */

  {
    question_code: "6.1",
    main_topic: "Environmental Incident Reporting",
    sub_topic: "Incident Reporting",
    question_text:
      "Do you have systems and processes in place to detect and action environmental incidents?",
    answer: "",
    comment: "",
  },
  {
    question_code: "6.2",
    main_topic: "Environmental Incident Reporting",
    sub_topic: "Incident Reporting",
    question_text:
      "Have any environmental incidents occurred during the audit scope period?",
    answer: "",
    comment: "",
  },
  {
    question_code: "6.3",
    main_topic: "Environmental Incident Reporting",
    sub_topic: "Incident Reporting",
    question_text:
      "If yes, have you reported those incidents to EPA or other agencies?",
    answer: "",
    comment: "",
  },
  {
    question_code: "6.4",
    main_topic: "Environmental Incident Reporting",
    sub_topic: "Incident Reporting",
    question_text: "Have you also provided reports to the Regulator?",
    answer: "",
    comment: "",
  },
  {
    question_code: "6.5",
    main_topic: "Environmental Incident Reporting",
    sub_topic: "Incident Reporting",
    question_text:
      "Were those reports submitted to the Regulator within the seven day timeframe?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 7 – RESOURCE RECOVERY
  ================================ */

  {
    question_code: "7.1",
    main_topic: "Resource Recovery",
    sub_topic: "Resource Recovery",
    question_text: "Are you actively working your mining lease(s)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "7.2",
    main_topic: "Resource Recovery",
    sub_topic: "Resource Recovery",
    question_text:
      "Do you submit production quantities to Division of Resources and Geosciences?",
    answer: "",
    comment: "",
  },
  {
    question_code: "7.3",
    main_topic: "Resource Recovery",
    sub_topic: "Resource Recovery",
    question_text:
      "Has the Geological Survey of NSW raised any concerns with you about recovery of resources? Have these concerns been acted upon?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 8 – SECURITY
  ================================ */

  {
    question_code: "8.1",
    main_topic: "Security",
    sub_topic: "Security Deposit",
    question_text: "Have you paid the required security amount?",
    answer: "",
    comment: "",
  },
  {
    question_code: "8.2",
    main_topic: "Security",
    sub_topic: "Security Deposit",
    question_text:
      "Have you provided a rehabilitation cost estimate at required intervals or triggers (for example, at renewal, when submitting the annual environmental management report or when submitting the mining operations plan)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "8.3",
    main_topic: "Security",
    sub_topic: "Security Deposit",
    question_text:
      "Was your rehabilitation cost estimate prepared using the Regulator's rehabilitation cost estimation tool?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 9 – COOPERATION AGREEMENT
  ================================ */

  {
    question_code: "9.1",
    main_topic: "Cooperation Agreement",
    sub_topic: "Overlapping Titles",
    question_text:
      "Are there any other mining or exploration titles that overlap with your title(s)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.2",
    main_topic: "Cooperation Agreement",
    sub_topic: "Overlapping Titles",
    question_text:
      "If there are overlapping titles, have you attempted to negotiate a co-operation agreement with the overlapping titleholder?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.i",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Access arrangements?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.ii",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Operational interaction procedures?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.iii",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Dispute resolution?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.iv",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Information exchange?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.v",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Drillhole location?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.vi",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Timing of drilling?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.vii",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Potential resource extraction conflicts?",
    answer: "",
    comment: "",
  },
  {
    question_code: "9.3.viii",
    main_topic: "Cooperation Agreement",
    sub_topic: "Cooperation Agreement Contents",
    question_text:
      "If you have prepared a cooperation agreement with the overlapping titleholder, does it address: Rehabilitation issues?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 10 – EXPLORATION REPORTING
  ================================ */

  {
    question_code: "10.1",
    main_topic: "Exploration Reporting",
    sub_topic: "Reporting",
    question_text:
      "Do you have systems and processes in place to track reporting dates?",
    answer: "",
    comment: "",
  },
  {
    question_code: "10.2",
    main_topic: "Exploration Reporting",
    sub_topic: "Reporting",
    question_text:
      "Have you submitted annual exploration reports in accordance with the guideline?",
    answer: "",
    comment: "",
  },
  {
    question_code: "10.3",
    main_topic: "Exploration Reporting",
    sub_topic: "Reporting",
    question_text:
      "Do you submit your reports within the 30 day timeframe after grant anniversary date?",
    answer: "",
    comment: "",
  },
  {
    question_code: "10.4",
    main_topic: "Exploration Reporting",
    sub_topic: "Reporting",
    question_text:
      "If you have been unable to submit your reports within the required timeframes, have you applied for and been granted extensions of time to lodge reports?",
    answer: "",
    comment: "",
  },
  {
    question_code: "10.5",
    main_topic: "Exploration Reporting",
    sub_topic: "Reporting",
    question_text:
      "Have any exemptions been granted to prepare and lodge reports about the titles?",
    answer: "",
    comment: "",
  },
  {
    question_code: "10.6",
    main_topic: "Exploration Reporting",
    sub_topic: "Reporting",
    question_text:
      "Have you prepared your exploration reports in accordance with the guideline 'Exploration Reporting: A guide for reporting on exploration and prospecting in NSW' and relevant DRG templates?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 11 – EXTRACTION PLAN (COAL TITLES ONLY)
  ================================ */

  {
    question_code: "11.1",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Extraction Plan",
    question_text: "Are you undertaking underground mining?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.2",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Extraction Plan",
    question_text:
      "Have you prepared and had approved an extraction plan for the underground operations?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.3",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Extraction Plan",
    question_text:
      "Does your extraction plan identify the risks associated with subsidence resulting from mining operations?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.4",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Extraction Plan",
    question_text: "Have you identified appropriate risk controls?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.5",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Extraction Plan",
    question_text: "Have those risk controls been implemented?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.6",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Extraction Plan",
    question_text:
      "Do you have systems and processes for monitoring the implementation of the risk controls?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.7",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Extraction Plan",
    question_text:
      "Have you undertaken any assessment of the effectiveness of the risk controls?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.8.i",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Regulator Notifications",
    question_text:
      "Have you made any notifications to the Regulator for any: Incident caused by subsidence that has a potential to expose any person to health and safety risks?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.8.ii",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Regulator Notifications",
    question_text:
      "Have you made any notifications to the Regulator for any: Significant deviation from the predicted nature, magnitude, distribution, timing and duration of subsidence effects, and of the potential impacts and consequences of those deviations on built features and the health and safety of any person?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.8.iii",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Regulator Notifications",
    question_text:
      "Have you made any notifications to the Regulator for any: Significant failure or malfunction of a monitoring device or risk control measure set out in the approved extraction plan addressing built features, public safety or subsidence monitoring?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.9",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Regulator Notifications",
    question_text:
      "If yes to any part of question 8, were the notifications made within the 48 hour timeframe specified?",
    answer: "",
    comment: "",
  },
  {
    question_code: "11.10",
    main_topic: "Extraction Plan (Coal Titles Only)",
    sub_topic: "Regulator Notifications",
    question_text:
      "Where incidents, significant deviations or failures have occurred, were appropriate corrective and preventive actions identified and implemented?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 12 – MINING OR PROSPECTING WITHOUT AUTHORISATION
  ================================ */

  {
    question_code: "12.1",
    main_topic: "Mining or Prospecting Without Authorisation",
    sub_topic: "Authorisation Compliance",
    question_text:
      "Are you undertaking your mining operations in accordance with the conditions of your authorisation(s)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "12.2",
    main_topic: "Mining or Prospecting Without Authorisation",
    sub_topic: "Authorisation Compliance",
    question_text:
      "Are you undertaking all mining operations and ancillary mining activities within your lease boundaries?",
    answer: "",
    comment: "",
  },
  {
    question_code: "12.3",
    main_topic: "Mining or Prospecting Without Authorisation",
    sub_topic: "Authorisation Compliance",
    question_text:
      "If not, does the exemption for ancillary mining activities apply?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 13 – APPLICATIONS FOR RENEWAL OF MINING LEASE
  ================================ */

  {
    question_code: "13.1",
    main_topic: "Applications for Renewal of Mining Lease",
    sub_topic: "Renewal",
    question_text:
      "Have you renewed your mining lease/s during the audit scope period?",
    answer: "",
    comment: "",
  },
  {
    question_code: "13.2",
    main_topic: "Applications for Renewal of Mining Lease",
    sub_topic: "Renewal",
    question_text:
      "Was the renewal application made on the standard departmental form?",
    answer: "",
    comment: "",
  },
  {
    question_code: "13.3",
    main_topic: "Applications for Renewal of Mining Lease",
    sub_topic: "Renewal",
    question_text:
      "Was a renewal justification statement included with the application?",
    answer: "",
    comment: "",
  },
  {
    question_code: "13.4",
    main_topic: "Applications for Renewal of Mining Lease",
    sub_topic: "Renewal",
    question_text:
      "Was a rehabilitation cost estimate provided with the application?",
    answer: "",
    comment: "",
  },
  {
    question_code: "13.5",
    main_topic: "Applications for Renewal of Mining Lease",
    sub_topic: "Renewal",
    question_text:
      "Was a statement of corporate compliance, environmental performance history and financial capability provided with the application?",
    answer: "",
    comment: "",
  },
  {
    question_code: "13.6",
    main_topic: "Applications for Renewal of Mining Lease",
    sub_topic: "Renewal",
    question_text:
      "Was a copy of the development consent included with the application?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 14 – SECTION 163C REPORTS
  ================================ */

  {
    question_code: "14.1",
    main_topic: "Section 163C Reports",
    sub_topic: "Exploration Reports",
    question_text:
      "Have you prepared and submitted annual reports for your exploration licence?",
    answer: "",
    comment: "",
  },
  {
    question_code: "14.2",
    main_topic: "Section 163C Reports",
    sub_topic: "Exploration Reports",
    question_text:
      "If you have relinquished parts of your licence area, have you prepared and submitted partial relinquishment reports?",
    answer: "",
    comment: "",
  },
  {
    question_code: "14.3",
    main_topic: "Section 163C Reports",
    sub_topic: "Exploration Reports",
    question_text:
      "If you are cancelling or not renewing your exploration licence, have you prepared and submitted a final report?",
    answer: "",
    comment: "",
  },
  {
    question_code: "14.4",
    main_topic: "Section 163C Reports",
    sub_topic: "Exploration Reports",
    question_text:
      "Have you submitted all required maps, plans and data in the required formats?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 15 – SECTION 163D RECORD KEEPING
  ================================ */

  {
    question_code: "15.1",
    main_topic: "Section 163D Record Keeping",
    sub_topic: "Record Keeping",
    question_text:
      "Do you have systems and processes in place to capture and maintain required records?",
    answer: "",
    comment: "",
  },
  {
    question_code: "15.2",
    main_topic: "Section 163D Record Keeping",
    sub_topic: "Record Keeping",
    question_text: "Are your records well-organised and stored properly?",
    answer: "",
    comment: "",
  },
  {
    question_code: "15.3",
    main_topic: "Section 163D Record Keeping",
    sub_topic: "Record Keeping",
    question_text: "Are your all records readily retrievable?",
    answer: "",
    comment: "",
  },
  {
    question_code: "15.4",
    main_topic: "Section 163D Record Keeping",
    sub_topic: "Record Keeping",
    question_text:
      "Have you provided all data to the department in accordance with the exploration reporting guideline requirements?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 16 – SECTION 282 LIABILITY TO PAY ROYALTY
  ================================ */

  {
    question_code: "16.1",
    main_topic: "Section 282 Liability to Pay Royalty",
    sub_topic: "Royalty",
    question_text:
      "Do you have systems and processes in place to remind you when your royalty returns and payments are due?",
    answer: "",
    comment: "",
  },
  {
    question_code: "16.2",
    main_topic: "Section 282 Liability to Pay Royalty",
    sub_topic: "Royalty",
    question_text: "Have you provided royalty returns as required?",
    answer: "",
    comment: "",
  },
  {
    question_code: "16.3",
    main_topic: "Section 282 Liability to Pay Royalty",
    sub_topic: "Royalty",
    question_text: "Have your royalty payments been made by the due dates?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 17 – ANNUAL RENTAL FEE AND ANNUAL ADMINISTRATIVE LEVY
  ================================ */

  {
    question_code: "17.1",
    main_topic: "Annual Rental Fee and Annual Administrative Levy",
    sub_topic: "Fees and Levies",
    question_text:
      "Do you have systems and processes in place to remind you when your rent and levy payments are due?",
    answer: "",
    comment: "",
  },
  {
    question_code: "17.2",
    main_topic: "Annual Rental Fee and Annual Administrative Levy",
    sub_topic: "Fees and Levies",
    question_text: "Have you paid your rents and levies by the due dates?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 18 – SUSPENSION OF MINING OPERATIONS
  ================================ */

  {
    question_code: "18.1",
    main_topic: "Suspension of Mining Operations",
    sub_topic: "Suspension",
    question_text: "Have you suspended your mining operations?",
    answer: "",
    comment: "",
  },
  {
    question_code: "18.2",
    main_topic: "Suspension of Mining Operations",
    sub_topic: "Suspension",
    question_text:
      "If yes, was approval applied for and granted for the suspension of operations?",
    answer: "",
    comment: "",
  },
  {
    question_code: "18.3",
    main_topic: "Suspension of Mining Operations",
    sub_topic: "Suspension",
    question_text:
      "Were any conditions attached to the approval to suspend operations?",
    answer: "",
    comment: "",
  },
  {
    question_code: "18.4",
    main_topic: "Suspension of Mining Operations",
    sub_topic: "Suspension",
    question_text: "Have you complied with those conditions?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 19 – COMPLIANCE MANAGEMENT
  ================================ */

  {
    question_code: "19.1",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text: "Have you identified your compliance requirements?",
    answer: "",
    comment: "",
  },
  {
    question_code: "19.2",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text:
      "Have you undertaken any analysis of your compliance risks in relation to possible causes and sources of non-compliance?",
    answer: "",
    comment: "",
  },
  {
    question_code: "19.3",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text:
      "Are there any systems in place to monitor and track compliance requirements?",
    answer: "",
    comment: "",
  },
  {
    question_code: "19.4",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text:
      "Is there a system in place to manage non-compliances that are identified?",
    answer: "",
    comment: "",
  },
  {
    question_code: "19.5",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text:
      "Is there a system in place to identify and manage change (for example, a new hardstand facility might require a MOP amendment)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "19.6",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text:
      "Are changes to compliance requirements and controls communicated to operational personnel (for example, is there a toolbox talk process or similar)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "19.7",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text:
      "Are there effective mechanisms in place for internal communication?",
    answer: "",
    comment: "",
  },
  {
    question_code: "19.8",
    main_topic: "Compliance Management",
    sub_topic: "Compliance Management",
    question_text:
      "Do you evaluate your compliance with a view to continual improvement of performance?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 20 – RISK IDENTIFICATION AND ASSESSMENT
  ================================ */

  {
    question_code: "20.1",
    main_topic: "Risk Identification and Assessment",
    sub_topic: "Risk Assessment",
    question_text:
      "Have you undertaken any process mapping and risk assessment to identify key issues for your operation?",
    answer: "",
    comment: "",
  },
  {
    question_code: "20.2",
    main_topic: "Risk Identification and Assessment",
    sub_topic: "Risk Assessment",
    question_text:
      "Where key issues are identified, have appropriate controls been put in place to manage those risks?",
    answer: "",
    comment: "",
  },
  {
    question_code: "20.3",
    main_topic: "Risk Identification and Assessment",
    sub_topic: "Risk Assessment",
    question_text:
      "Does the risk identification and assessment address operational and environmental risks as well as safety risks?",
    answer: "",
    comment: "",
  },
  {
    question_code: "20.4",
    main_topic: "Risk Identification and Assessment",
    sub_topic: "Risk Assessment",
    question_text:
      "Is the risk assessment regularly reviewed and updated as necessary?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 21 – MANAGING YOUR CONTRACTORS
  ================================ */

  {
    question_code: "21.1",
    main_topic: "Managing Your Contractors",
    sub_topic: "Contractor Management",
    question_text:
      "Do you use any subcontracted services (for example, drillers, trucking, or other services)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "21.2",
    main_topic: "Managing Your Contractors",
    sub_topic: "Contractor Management",
    question_text:
      "Do you communicate any relevant key issues and controls to the subcontractor (for example, performance specifications, induction processes, or other issues and controls)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "21.3",
    main_topic: "Managing Your Contractors",
    sub_topic: "Contractor Management",
    question_text:
      "Do you monitor the activities of the subcontractor (for example, surveillance, audits, inspection or through other means)?",
    answer: "",
    comment: "",
  },
  {
    question_code: "21.4",
    main_topic: "Managing Your Contractors",
    sub_topic: "Contractor Management",
    question_text:
      "Do you obtain copies of key records generated by subcontractors to verify compliance with your obligations as a title holder (for example, borehole sealing records, drilling records, or other records)?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 22 – INSPECTING, MONITORING AND EVALUATING
  ================================ */

  {
    question_code: "22.1",
    main_topic: "Inspecting, Monitoring and Evaluating",
    sub_topic: "Monitoring and Evaluation",
    question_text:
      "Do you have systems in place for the inspection, monitoring, and evaluation of key risk controls?",
    answer: "",
    comment: "",
  },
  {
    question_code: "22.2",
    main_topic: "Inspecting, Monitoring and Evaluating",
    sub_topic: "Monitoring and Evaluation",
    question_text: "Are inspections documented?",
    answer: "",
    comment: "",
  },
  {
    question_code: "22.3",
    main_topic: "Inspecting, Monitoring and Evaluating",
    sub_topic: "Monitoring and Evaluation",
    question_text:
      "Is there a closeout loop to ensure any non-compliances or defects identified can be tracked, addressed and closed out?",
    answer: "",
    comment: "",
  },
  {
    question_code: "22.4",
    main_topic: "Inspecting, Monitoring and Evaluating",
    sub_topic: "Monitoring and Evaluation",
    question_text:
      "Is there periodic review and evaluation of monitoring and inspection results to verify controls are effective, or identify any trends in particular issues?",
    answer: "",
    comment: "",
  },
  {
    question_code: "22.5",
    main_topic: "Inspecting, Monitoring and Evaluating",
    sub_topic: "Monitoring and Evaluation",
    question_text:
      "Where incidents occur, are there adequate processes in place for reporting these?",
    answer: "",
    comment: "",
  },
  {
    question_code: "22.6",
    main_topic: "Inspecting, Monitoring and Evaluating",
    sub_topic: "Monitoring and Evaluation",
    question_text:
      "Are there any internal reporting systems, and is information from these systems and processes used in the decision-making process?",
    answer: "",
    comment: "",
  },
  {
    question_code: "22.7",
    main_topic: "Inspecting, Monitoring and Evaluating",
    sub_topic: "Monitoring and Evaluation",
    question_text: "Is there any form of management review?",
    answer: "",
    comment: "",
  },

  /* ===============================
   PART 23 – TRAINING AND COMPETENCY
  ================================ */

  {
    question_code: "23.1",
    main_topic: "Training and Competency",
    sub_topic: "Training",
    question_text:
      "Have you identified core competencies required for positions?",
    answer: "",
    comment: "",
  },
  {
    question_code: "23.2",
    main_topic: "Training and Competency",
    sub_topic: "Training",
    question_text:
      "Is there a skills matrix or other similar tool used to identify any training gaps?",
    answer: "",
    comment: "",
  },
  {
    question_code: "23.3",
    main_topic: "Training and Competency",
    sub_topic: "Training",
    question_text: "Are training records documented?",
    answer: "",
    comment: "",
  },
  {
    question_code: "23.4",
    main_topic: "Training and Competency",
    sub_topic: "Training",
    question_text:
      "Is there a system in place to monitor training expiry dates and program any required re-training?",
    answer: "",
    comment: "",
  },
  {
    question_code: "23.5",
    main_topic: "Training and Competency",
    sub_topic: "Training",
    question_text:
      "Is there an induction program and does it address key operational, environmental, and safety risks?",
    answer: "",
    comment: "",
  },
];

export default questions;
