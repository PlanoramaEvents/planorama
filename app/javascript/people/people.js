import {PERSON_CON_STATE, SESSION_STATUS} from "@/constants/strings";
import { personScheduleApprovalStateOptionsForSearch } from "@/store/person_schedule_approval";

export const people_columns = [
  {
    key: 'published_name',
    label: 'Published Name',
    type: "text",
    sortable: true,
    class: 'col-name-field',
    stickyColumn: true
  },
  {
    key: 'name',
    label: 'Name',
    type: "text",
    sortable: true,
    class: 'col-name-field'
  },
  {
    key: 'pronouns',
    label: 'Pronouns',
    type: "text",
    sortable: false
  },
  {
    key: 'primary_email',
    search_key: 'email_addresses.email',
    label: 'Email',
    type: "text",
    sortable: false
  },
  {
    key: 'con_state',
    search_key: 'con_state',
    label: 'Status',
    type: "select",
    formatter: (value) => PERSON_CON_STATE[value] || value,
    choices: [
      "not_set", "applied", "vetted", "wait_list", "invite_pending",
      "invited", "probable", "accepted", "declined", "rejected"
    ].map(value => ({label: PERSON_CON_STATE[value], value})),
    operators: ["equals", "does not equal"],
    sortable: false
  },
  {
    key: 'attendance_type',
    label: 'Attendance Type'
  },
  {
    key: 'session_count',
    search_key: 'session_count',
    label: 'Session Count',
    sortable: true,
    type: "numeric",
    operators: ["equals", "does not equal", "is less than", "is less than or equal to", "is greater than", "is greater than or equal to"]
  },
  {
    key: 'draft_approval',
    label: 'Draft Approved',
    search_key: 'draft_person_schedule_approvals.approved',
    type: "select",
    choices: personScheduleApprovalStateOptionsForSearch,
    sortable: false
  },
  {
    key: 'draft_comments',
    label: 'Draft Comments',
    sortable: false
  },
  {
    key: 'firm_approval',
    label: 'Firm Approved',
    search_key: 'firm_person_schedule_approvals.approved',
    type: "select",
    choices: personScheduleApprovalStateOptionsForSearch,
    sortable: false
  },
  {
    key: 'firm_comments',
    label: 'Firm Comments',
    sortable: false
  },
  {
    key: 'gender',
    label: 'Gender',
    type: "text",
    sortable: false
  },
  {
    key: 'comments',
    label: 'Notes',
    type: "text",
    sortable: false
  },
  {
    key: 'current_sign_in_at',
    label: 'Last Logged In',
    sortable: false
  }
];
