const twoLines = (line1, line2) => (h) =>  h('p', {}, [line1, h('br'), line2]);
const errorMessage = (message) => (errorCode) => twoLines(message, `Error code: ${errorCode}`);
const titleCase = (model) => `${model.substring(0, 1).toUpperCase()}${model.substring(1)}`;
const nLines = (lines) => (h) => h('p', {}, lines.reduce((p, c) => [...p, c, h('br')], []))

module.exports = {
    // login page
    LOGIN_401: "The username or password you entered is incorrect. Please check your spelling and try again.",
    LOGIN_MISSING_PASSWORD: "You must enter a valid password.",
    LOGIN_INVALID_FIELDS: "You must provide all of your login information.",
    MISSING_EMAIL: "You must enter a valid email address.",
    NOT_AN_EMAIL: "Email address needs to be in the correct format e.g. xyz@test.com",
    LOGIN_SHORT_PASSWORD: "Your password must be at least 6 characters long.",
    LOGIN_PASSWORDS_DO_NOT_MATCH: "Your passwords do not match.",
    SOMETHING_WENT_WRONG: (helpEmail) => `Oops, something went wrong on our end. Please try again in a few minutes or contact us at ${helpEmail} if the problem persists.`,
    LOGIN_MISSING_NEW_PASSWORD: "You must enter a new password.",
    LOGIN_PASSWORDS_MUST_MATCH: "Your passwords must match.",
    LOGIN_PASSWORD_INVALID: "Your new password must meet the security criteria.",
    LOGIN_PASSWORD_RESET_EMAIL_SEND: "If an account with the address you specified exists you will receive an email with a password reset link.",
    LOGIN_PASSWORD_CHANGED: "You successfully changed your password.",
    LOGIN_TOKEN_EXPIRED: (resetPasswordLink) => `The password reset link you used is no longer valid. Please request another link here: ${resetPasswordLink}`,
    LOGIN_CLICK_TO_AGREE: (conventionName) => `By clicking ‘Log In’ below, I agree to ${conventionName} storing and using my personal data as documented in the`,

    // toast titles
    ERROR_TOAST_TITLE: "Error",
    SUCCESS_TOAST_TITLE: "Success",

    //survey actions
    SURVEY_SAVE_SUCCESS: "Survey successfully saved.",
    SURVEY_SAVE_ERROR: errorMessage("Survey failed to be saved."),
    SURVEY_CONFIRM_PUBLISH: "You are about to publish this survey. This will make the survey visible to the public and allow responses to be collected. Are you sure you want to publish this survey?",
    SURVEY_CONFIRM_CLOSE: "You are about to close this survey. This will no longer allow any responses to be collected. Are you sure you want to close this survey?",
    SURVEY_CONFIRM_DELETE: "Are you sure you want to permanently delete this survey? This cannot be undone.",
    SURVEY_SAVE_SUCCESS_PUBLISH: "Survey successfully published.",
    SURVEY_SAVE_ERROR_PUBLISH: errorMessage("Survey failed to be published."),
    SURVEY_SAVE_SUCCESS_CLOSE: "Survey successfully closed.",
    SURVEY_SAVE_ERROR_CLOSE: errorMessage("Survey failed to be closed."),
    SURVEY_SAVE_SUCCESS_DELETE: "Survey successfully deleted.",
    SURVEY_SAVE_ERROR_DELETE: errorMessage("Survey failed to be deleted."),
    SURVEY_SAVE_SUCCESS_ADD: "Survey successfully added.",
    SURVEY_SAVE_ERROR_ADD: errorMessage("Survey failed to be added."),

    // survey results actions
    SURVEY_RESULTS_CLEAR_SUCCESS: "Results successfully cleared.",
    SURVEY_RESULTS_CLEAR_ERROR: errorMessage("Results failed to be cleared."),
    SURVEY_RESULTS_CLEAR_CONFIRM: "This will permanently delete all responses to this survey. Are you sure you wish to clear all responses?",
    SURVEY_RESULTS_FREEZE_SUCCESS: "Response edits successfully frozen.",
    SURVEY_RESULTS_FREEZE_ERROR: errorMessage("Response edits failed to be frozen."),
    SURVEY_RESULTS_UNFREEZE_SUCCESS: "Response edits successfully unfrozen.",
    SURVEY_RESULTS_UNFREEZE_ERROR: errorMessage("Response edits failed to be unfrozen."),

    //survey defaults
    SURVEY_DEFAULT_THANK_YOU: "Your responses have been recorded.",

    //survey restrictions
    SURVEY_NOT_ASSIGNED: "This survey hasn't been assigned to you.",

    //survey questions
    SURVEY_YESNOMAYBE_PLACEHOLDER: "Please elaborate here.",
    SURVEY_LINKED_FIELD: "This answer is linked directly to a profile field. Any information in that field will be mirrored here, and editing this information will edit your profile. Linked fields have a special icon: ",
    SURVEY_LINKED_FIELD1: "Any field marked with (",
    SURVEY_LINKED_FIELD2: ") is linked directly to a profile field. Any information from that field is mirrored here, and editing that information will edit your profile.",

    //generic app wide
    NOT_IMPLEMENTED: "This feature is not yet implemented. Check back soon!",
    ADMIN_ADD_AGREEMENT_SUCCESS: (title) => `${title} successfully added to Planorama.`,
    ADMIN_ADD_USER_SUCCESS: (name) => `${name} successfully added to Planorama.`,
    ADMIN_ADD_USER_ERROR: (name) => errorMessage(`${name} failed to be added to Planorama.`),
    IEA_FAILURE_TO_SIGN: "As a member of Staff you can not proceed without agreeing to the ethics and data privacy statements.",
    MODEL_SAVE_SUCCESS: (model) => `${titleCase(model)} sucessfully saved.`,
    MODEL_SAVE_ERROR: (model) => errorMessage(`${titleCase(model)} failed to be saved.`),
    MODEL_ADD_SUCCESS: (model) => `${titleCase(model)} sucessfully added.`,
    MODEL_ADD_ERROR: (model) => errorMessage(`${$titleCase(model)} failed to be added.`),
    MODEL_DELETE_SUCCESS: (model) => `${titleCase(model)} sucessfully deleted.`,
    MODEL_DELETE_ERROR: (model) => errorMessage(`${titleCase(model)} failed to be deleted.`),
    MODEL_MASS_UPDATE_SUCCESS: (model) => `All ${titleCase(model)} sucessfully updated.`,
    MODEL_MASS_UPDATE_ERROR: (model) => errorMessage(`All ${titleCase(model)} failed to be updated.`),

    // Mailing messages
    MAILING_SCHEDULED: (title) => `The mailing ${title} has been scheduled.`,
    MAILING_TEST_SCHEDULED: (title) => `A test of the mailing ${title} has been scheduled.`,
    MAILING_CLONED: (title) => `A clone of the mailing ${title} has been created.`,

    //question actions
    QUESTION_ORDER_SAVE_SUCCESS: "Question reorder successfully saved.",
    QUESTION_ORDER_SAVE_ERROR: errorMessage("Question reorder failed to be saved."),
    QUESTION_SAVE_SUCCESS: "Question successfully saved.",
    QUESTION_SAVE_ERROR: errorMessage("Question failed to be saved."),
    QUESTION_DELETE_SUCCESS: "Question successfully deleted.",
    QUESTION_DELETE_ERROR: errorMessage("Question failed to be deleted."),
    QUESTION_DUPLICATE_SUCCESS: "Question successfully duplicated.",
    QUESTION_DUPLICATE_ERROR: errorMessage("Question failed to be duplicated."),
    QUESTION_ADD_SAVE_SUCCESS: "Question successfully added.",
    QUESTION_ADD_SAVE_ERROR: errorMessage("Question failed to be added."),
    QUESTION_UNCHANGED: "Question change abandoned.",
    QUESTION_MODAL_MESSAGE: "You are changing the question type and there's a linked field associated with that specific question type. If you continue with changing the question type, we will remove the linked field. You can choose to leave the question type as it is and the linking will remain.",

    //answer actions
    ANSWER_ORDER_SAVE_SUCCESS: "Answer reorder sucessfully saved.",
    ANSWER_ORDER_SAVE_ERROR: errorMessage("Answer reorder failed to be saved."),
    ANSWER_SAVE_SUCCESS: "Answer sucessfully saved.",
    ANSWER_SAVE_ERROR: errorMessage("Answer failed to be saved."),
    ANSWER_ADD_SUCCESS: "Answer sucessfully added.",
    ANSWER_ADD_ERROR: errorMessage("Answer failed to be added."),

    // session interest
    SESSION_INTEREST_SUCCESS: "Session Interest saved.",
    SESSION_INTEREST_ERROR: errorMessage("Session Interest failed to be saved."),
    SESSION_INTEREST_REMOVE_SUCCESS: "Session Interest removed.",
    SESSION_INTEREST_REMOVE_ERROR: errorMessage("Session Interest failed to be removed."),
    SESSION_ASSIGNMENT_SUCCESS: "Session Assignment saved.",
    SESSION_ASSIGNMENT_ERROR: errorMessage("Session Assignment failed to be saved."),
    SESSION_INTEREST_UPDATE_SUCCESS: "Session Interest updated.",
    SESSION_INTEREST_UPDATE_ERROR: errorMessage("Session Interest failed to be updated."),

    SESSION_SAVE_SUCCESS_DELETE: "Session successfully deleted.",
    SESSION_SAVE_ERROR_DELETE: errorMessage("Session failed to be deleted."),
    SESSION_SAVE_SUCCESS: "Session successfully saved.",
    SESSION_SAVE_ERROR: errorMessage("Session failed to be saved."),

    SESSION_RANKING_ERROR: (total, allowed) => `You have assigned ${total} which exceeds the allowed ${allowed}.`,

    CONFIGURATION_SAVED_SUCCESS: "Configuration has been saved.",
    CONFIGURATION_SAVED_ERROR: errorMessage("Error on config save."),

    CREATE_SESSION_LIMIT_SUCCESS: "Session limit has been saved.",
    CREATE_SESSION_LIMIT_ERROR: errorMessage("Error on session limit save."),

    AVAILABILITY_DESCRIPTION: "Under each day, please highlight (click and drag) the times you are available in the calendar view below.",
    SAVE_AVAILABILITY_NOTES: "Other scheduling considerations saved successfully.",
    AVAILABILITY_NOTES_LABEL: "Other Scheduling Considerations",

    UPDATE_PERSON_EXCLUSION_SUCCESS: "Exclusion information has been updated.",
    UPDATE_PERSON_EXCLUSION_ERROR: errorMessage("Error on updating exclusion information."),
    GET_PERSON_EXCLUSION_SUCCESS: "Exclusion information has been retrieved.",
    GET_PERSON_EXCLUSION_ERROR: errorMessage("Error on retrieving exclusion information."),

    UPDATE_AVAILABILITY_SUCCESS: "Availability has been updated.",
    UPDATE_AVAILABILITY_ERROR: errorMessage("Error on updating availability."),

    ADD_EMAIL_SUCCESS: "Email has been added.",
    ADD_EMAIL_ERROR: errorMessage("Error on add email."),

    //page actions
    PAGE_DELETE_SUCCESS: "Page successfully deleted.",
    PAGE_DELETE_ERROR: errorMessage("Page failed to be deleted."),
    PAGE_MERGE_SUCCESS: "Page successfully merged.",
    PAGE_MERGE_ERROR: errorMessage("Page failed to be merged."),
    SURVEY_CONFIRM_DELETE_PAGE_1: "Deleting a page also deletes the questions and response options it contains.",
    SURVEY_CONFIRM_DELETE_PAGE_2: "To preserve the questions, choose \"Merge page up\" from the page options.",
    PAGE_ADD_SUCCESS: "Page successfully added.",
    PAGE_ADD_ERROR: errorMessage("Page failed to be added."),
    PAGE_SAVE_SUCCESS: "Page successfully saved.",
    PAGE_SAVE_ERROR: errorMessage("Page failed to be saved."),

    //venues
    VENUES_ADD_ROOM_SUCCESS: (name) => `${name} successfully added.`,
    VENUES_ADD_ROOMSET_SUCCESS: (name) => `${name} successfully added.`,
    VENUES_ADD_VENUE_SUCCESS: (name) => `${name} successfully added.`,

    // linked field names
    LINKED_FIELD_LABELS: {
        Person: {
            name: "Name",
            pseudonym: "Published Name",
            pronouns: "Pronouns",
            gender: "Gender",
            ethnicity: "Race and/or ethnicity",
            age_at_convention: "Age at convention",
            romantic_sexual_orientation: "Romantic and/or sexual orientation",
            bio: "Bio",
            can_stream_exceptions: "Topics not to stream",
            can_record_exceptions: "Topics not to record",
            accommodations: "Accessibility details",
            moderation_experience: "Moderation experience",
            othered: "Othered?",
            indigenous: "Indigenous?",
            black_diaspora: "Black diaspora?",
            non_us_centric_perspectives: "Not US-centric?",
            demographic_categories: "Further demographic categories",
            do_not_assign_with: "Do not assign with",
            attendance_type: "Attendance type",
            can_stream: "Permission to livestream",
            can_record: "Permission to record",
            can_photo: "Permission to photograph",
            needs_accommodations: "Needs access accommodation",
            is_local: "Is a local",
            willing_to_moderate: "Moderation interest",
            languages_fluent_in: "Fluent languages",
            contact_email: "Contact email",
        },
    },
    nLines,

    ERROR_GENERIC_RECOVERABLE: (email) => twoLines("The server has encountered an internal error and was unable to complete your request.",
    `Please contact the server administrator at ${email} and let them know the time and date the error occurred.`),
    ERROR_GENERIC_UNRECOVERABLE: (email) => twoLines("The server has encountered an internal error and was unable to complete your request.",
    `Please contact the server administrator at ${email} and let them know the time and date the error occurred.`),

    ADD_CONFLICT_IGNORE_SUCCESS: "Ignore Conflict Added",
    ADD_CONFLICT_IGNORE_ERROR: "Ignore Conflict Failed",

    // Social Links Errors
    TWITTER_ID_INVALID_MSG: "Twitter ID is not in a valid format",
    FACEBOOK_ID_INVALID_MSG: "Facebook ID is not in a valid format",
    WEBSITE_INVALID_MSG: "Website is not in a valid format",
    INSTAGRAM_ID_INVALID_MSG: "Instagram ID is not in a valid format",
    TWITCH_ID_INVALID_MSG: "Twitch ID is not in a valid format",
    YOUTUBE_ID_INVALID_MSG: "Youtube is not in a valid format",
    TIKTOK_ID_INVALID_MSG: "TikTok ID is not in a valid format",
    LINKEDIN_ID_INVALID_MSG: "LinkedIn ID is not in a valid format",
    PROFILE_FIELD_LABELS: {
        ethnicity: "Ethnicity",
        gender: "Gender",
        age_at_convention: "Age at time of event",
        romantic_sexual_orientation: "Romantic and/or sexual orientation",
        othered: "Experience with being \"othered\"",
        indigenous: "Member of an Indigenous community",
        black_diaspora: "Member of the global Black diaspora",
        non_us_centric_perspectives: "Represent something other than a purely US-centric perspective",
        demographic_categories: "Other demographic categories",
        twitter: "Twitter",
        facebook: "Facebook",
        website: "Website",
        instagram: "Instagram",
        twitch: "Twitch",
        youtube: "YouTube",
        tiktok: "TikTok",
        linkedin: "LinkedIn",
        othersocialmedia: "Other",
        do_not_assign_with: "Anyone that should not be assigned to be on a panel with participant",
        is_local: "Local to the event",
        moderation_experience: "Moderating Experience",
        can_stream: "Permission to be included in a livestreamed program",
        can_record: "Permission to be included in a recorded program",
        can_stream_exceptions: "Livestreams excluded topics",
        can_record_exceptions: "Recordings excluded topics",
        name: "Name",
        pseudonym: "Pseudonym",
        languages_fluent_in: "Languages spoken",
        can_share: "Permission to share email with other Participants",
        attendance_type: "Will attend convention",
        timezone: "Timezone during convention",
    },
    PERSON_SAVE_SUCCESS: "Profile record saved successfully",
    PERSON_NEVER_LOGGED_IN: "Never logged in",
    PERSON_CON_STATE: {
        not_set: "Not Set",
        applied: "Applied",
        vetted: "Vetted",
        wait_list: "Wait List",
        invite_pending: "Invite Pending",
        invited: "Invited",
        probable: "Probable",
        accepted: "Accepted",
        declined: "Declined",
        rejected: "Rejected"
    },
    PERSON_ATTENDANCE_TYPE: {
        'in person': "In Person",
        hybrid: "In Person AND Virtually",
        virtual: "Virtually",
    },

    SURVEY_REDIRECT: "Unfortunately due to the browser refreshing we have lost any answers you filled in. Please fill the survey out again.",
    SURVEY_PUBLIC_NO_EDIT: "You cannot edit a published survey. Close the survey to enable editing.",
    SURVEY_PUBLIC_NO_DELETE: "You cannot delete a published survey. Close the survey to enable deletion.",
    SESSION_ENVIRONMENT: {
        unknown: "Unknown",
        in_person: "In Person",
        hybrid: "Hybrid",
        virtual: "Virtual"
    },
    SESSION_STATUS: {
        draft: "Draft",
        reviewed: "Reviewed",
        revised: "Revised",
        dropped: "Dropped",
    },
    SESSION_MUST_UNSCHEDULE: "You must unschedule a session before dropping it",
    SESSION_MUST_UNDROP: "You must un-drop the session to be able to schedule it.",
    SESSION_MINORS_PARTICIPATION: {
        kids_observe: "Kids welcome to observe",
        kids_supervision: "Kids welcome to participate with supervision",
        kids_participate: "Kids welcome to participate",
        geared_families: "Geared towards families",
        geared_kids: "Geared towards kids",
    },
    SCHEDULE_DRAFT_CONFIRM_MESSAGE: "This will publish a Draft Schedule to all participants, who will see their own sessions.  This action is irreversible and will bring the server down for a short time. Please double check that you wish to perform this action.",
    SCHEDULE_FIRM_CONFIRM_MESSAGE: "This will publish a Firm Schedule to all participants, who will see their own sessions - live.  This action is irreversible. Please double check that you wish to perform this action.",
    SCHEDULE_DRAFT_SUCCESS_MESSAGE: "Draft schedule has been published successfully",
    SCHEDULE_FIRM_SUCCESS_MESSAGE: "Firm schedule has been published successfully",
    SCHEDULE_APPROVAL_FAIL_TO_LOAD: "Couldn't load the approval form. Try again soon.",
    // The below is intended to become a way to override defaults in the model mixin easily. Hasn't happened yet though.
    SPECIFIC_MODEL_SAVE_SUCCESS: {
        person_schedule_approval: {
            person_schedule_approval: "Schedule approval saved.",
            approved: (approvalType) => `${titleCase(approvalType)} approval was successfully saved.`,
            comments: (approvalType) => `${titleCase(approvalType)} approval comment was successfully saved.`,
        },
    },
    SPECIFIC_MODEL_SAVE_ERROR: {
        person_schedule_approval: {
            person_schedule_approval: errorMessage("Schedule approval was not saved."),
            approved: (approvalType) => errorMessage(`${titleCase(approvalType)} approval was not saved.`),
            comments: (approvalType) => errorMessage(`${titleCase(approvalType)} approval comment was not saved.`),
        },
    },
    EVENT_SETTINGS_MUST_RELOAD: "*** Changes to these settings will only take effect after you reload your browser page. ***",
    CONFIGURATION_LABEL_OVERRIDES: {
        event_virtual: "Does this event include a virtual component?"
    }
}
