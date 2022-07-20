/**
 * @readonly
 * @enum {string} whether the person has indicated approval
 */
export const PersonScheduleApprovalState = {
  NOT_SET: 'not_set',
  YES: 'yes',
  NO: 'no'
}

export const personScheduleApprovalStateOptions = [
  {text: 'Not Set', value: PersonScheduleApprovalState.NOT_SET},
  {text: 'Yes', value: PersonScheduleApprovalState.YES},
  {text: 'No', value: PersonScheduleApprovalState.NO},
];

export const personScheduleApprovalStateOptionsForSearch = 
  personScheduleApprovalStateOptions.map(i => ({...i, label: i.text}))

export const formatPersonScheduleApprovalState = (psa) => {
  if (!psa) {
    return 'Not Set';
  }
  return personScheduleApprovalStateOptions.find(({value}) => value === psa)?.text || psa;
}

/**
 * @typedef {Object} PersonScheduleApproval
 * @property {PersonScheduleApprovalState} approved
 * @property {Person} person
 * @property {import("@/store/schedule_workflow/schedule_workflow.model").ScheduleWorkflow} schedule_workflow
 * @property {string} comments
 */

export const personScheduleApprovalModel = 'person_schedule_approval'
