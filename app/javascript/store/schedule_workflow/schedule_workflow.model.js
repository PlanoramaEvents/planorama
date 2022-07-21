/**
 * @readonly
 * @enum {string} the state of the schedule workflow
 */
export const ScheduleWorkflowState = {
  NOT_SET: 'not_set',
  DRAFT: 'draft',
  FIRM: 'firm'
}

/**
 * @typedef {Object} ScheduleWorkflow
 * @property {ScheduleWorkflowState} state
 * @property {string} created_by
 * @property {DateTime} set_at
 * @property {ScheduleSnapshot} schedule_snapshot
 * also lock version and timestamps
 */

export const scheduleWorkflowModel = 'schedule_workflow'
