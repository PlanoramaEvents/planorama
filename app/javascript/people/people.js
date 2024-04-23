import { PERSON_CON_STATE, SESSION_STATUS } from "@/constants/strings";
import { personScheduleApprovalStateOptionsForSearch } from "@/store/person_schedule_approval";

export const people_columns = [
  {
    key: 'published_name',
    label: 'Opublikowana nazwa',
    type: "text",
    sortable: true,
    class: 'col-name-field',
    stickyColumn: true
  },
  {
    key: 'name',
    label: 'Imię i nazwisko',
    type: "text",
    sortable: true,
    class: 'col-name-field'
  },
  {
    key: 'pronouns',
    label: 'Zaimki',
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
    label: 'Typ uczestnictwa'
  },
  {
    key: 'session_count',
    search_key: 'session_count',
    label: 'Liczba sesji',
    sortable: true,
    type: "numeric",
    operators: ["equals", "does not equal", "is less than", "is less than or equal to", "is greater than", "is greater than or equal to"]
  },
  {
    key: 'draft_approval',
    label: 'Zatwierdzony projekt',
    search_key: 'draft_person_schedule_approvals.approved',
    type: "select",
    choices: personScheduleApprovalStateOptionsForSearch,
    sortable: false
  },
  {
    key: 'draft_comments',
    label: 'Komentarze do projektu',
    sortable: false
  },
  {
    key: 'firm_approval',
    label: 'Zatwierdzony przez firmę',
    search_key: 'firm_person_schedule_approvals.approved',
    type: "select",
    choices: personScheduleApprovalStateOptionsForSearch,
    sortable: false
  },
  {
    key: 'firm_comments',
    label: 'Komentarze firmy',
    sortable: false
  },
  {
    key: 'gender',
    label: 'Płeć',
    type: "text",
    sortable: false
  },
  {
    key: 'comments',
    label: 'Uwagi',
    type: "text",
    sortable: false
  },
  {
    key: 'current_sign_in_at',
    label: 'Ostatnie logowanie',
    sortable: false
  }
];
