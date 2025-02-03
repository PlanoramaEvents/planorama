function twoLines(line1, line2) { (h) =>  h('p', {}, [line1, h('br'), line2]) };
function errorMessage(message) {(errorCode) => twoLines(message, `Error code = ${errorCode}`)};
function titleCase(model) { `${model.substring(0, 1).toUpperCase()}${model.substring(1)}`};
// nLines = (lines) => (h) => h('p', {}, lines.reduce((p, c) => [...p, c, h('br')], []));

export function nLines(lines) {
  (h) => h('p', {}, lines.reduce((p, c) => [...p, c, h('br')], []));
};

// login page
export const    LOGIN_401 = "The username or password you entered is incorrect. Please check your spelling and try again.";
export const    LOGIN_MISSING_PASSWORD = "You must enter a valid password.";
export const    LOGIN_INVALID_FIELDS = "You must provide all of your login information.";
export const    MISSING_EMAIL = "You must enter a valid email address.";
export const    MISSING_NAME = "Your name must be at least one character long.";
export const    NOT_AN_EMAIL = "Email address needs to be in the correct format e.g. xyz@test.com";
export const    LOGIN_SHORT_PASSWORD = "Your password must be at least 6 characters long.";
export const    LOGIN_PASSWORDS_DO_NOT_MATCH = "Your passwords do not match.";
export const    LOGIN_PASSWORD_UNSECURE = "Your password does not meet the security requirements.";
export const    SOMETHING_WENT_WRONG = (helpEmail) => `Oops, something went wrong on our end. Please try again in a few minutes or contact us at ${helpEmail} if the problem persists.`;
export const    VALID_CAPTCHA_REQUIRED = "A valid response to the CAPTCHA is required";
export const    LOGIN_MISSING_NEW_PASSWORD = "You must enter a new password.";
export const    LOGIN_PASSWORDS_MUST_MATCH = "Your passwords must match.";
export const    LOGIN_PASSWORD_INVALID = "Your new password must meet the security criteria.";
export const    LOGIN_PASSWORD_RESET_EMAIL_SEND = "If an account with the address you specified exists you will receive an email with a password reset link.";
export const    LOGIN_PASSWORD_CHANGED = "You successfully changed your password.";
export const    LOGIN_NO_ROLE = (helpEmail) => `Your account has not been properly configured. Please contact ${helpEmail} for assistance.`;
export const    LOGIN_TOKEN_EXPIRED = (resetPasswordLink) => `The password reset link you used is no longer valid. Please request another link here: ${resetPasswordLink}`;
export const    LOGIN_CLICK_TO_AGREE = (conventionName) => `By clicking ‘Log In’ below, I agree to ${conventionName} storing and using my personal data as documented in the`;
export const    PASSWORDS_MUST_NOT_BE_RECENT = "The password entered was one you used recently, plase use a different password.";

// toast titles
export const    ERROR_TOAST_TITLE = "Error";
export const    SUCCESS_TOAST_TITLE = "Success";

export const ADMIN_ADD_ROOM_SUCCESS = "TODO";

//survey actions
export const    SURVEY_SAVE_SUCCESS = "Survey successfully saved.";
export const    SURVEY_SAVE_ERROR = errorMessage("Survey failed to be saved.");
export const    SURVEY_CONFIRM_PUBLISH = "You are about to publish this survey. This will make the survey visible to the public and allow responses to be collected. Are you sure you want to publish this survey?";
export const    SURVEY_CONFIRM_CLOSE = "You are about to close this survey. This will no longer allow any responses to be collected. Are you sure you want to close this survey?";
export const    SURVEY_CONFIRM_DELETE = "Are you sure you want to permanently delete this survey? This cannot be undone.";
export const    SURVEY_SAVE_SUCCESS_PUBLISH = "Survey successfully published.";
export const    SURVEY_SAVE_ERROR_PUBLISH = errorMessage("Survey failed to be published.");
export const    SURVEY_SAVE_SUCCESS_CLOSE = "Survey successfully closed.";
export const    SURVEY_SAVE_ERROR_CLOSE = errorMessage("Survey failed to be closed.");
export const    SURVEY_SAVE_SUCCESS_DELETE = "Survey successfully deleted.";
export const    SURVEY_SAVE_ERROR_DELETE = errorMessage("Survey failed to be deleted.");
export const    SURVEY_SAVE_SUCCESS_ADD = "Survey successfully added.";
export const    SURVEY_SAVE_ERROR_ADD = errorMessage("Survey failed to be added.");

// survey results actions
export const    SURVEY_RESULTS_CLEAR_SUCCESS = "Results successfully cleared.";
export const    SURVEY_RESULTS_CLEAR_ERROR = errorMessage("Results failed to be cleared.");
export const    SURVEY_RESULTS_CLEAR_CONFIRM = "This will permanently delete all responses to this survey. Are you sure you wish to clear all responses?";
export const    SURVEY_RESULTS_FREEZE_SUCCESS = "Response edits successfully frozen.";
export const    SURVEY_RESULTS_FREEZE_ERROR = errorMessage("Response edits failed to be frozen.");
export const    SURVEY_RESULTS_UNFREEZE_SUCCESS = "Response edits successfully unfrozen.";
export const    SURVEY_RESULTS_UNFREEZE_ERROR = errorMessage("Response edits failed to be unfrozen.");

//survey defaults
export const    SURVEY_DEFAULT_THANK_YOU = "Your responses have been recorded.";

//survey restrictions
export const    SURVEY_NOT_ASSIGNED = "This survey hasn't been assigned to you.";

//survey questions
export const    SURVEY_YESNOMAYBE_PLACEHOLDER = "Please elaborate here.";
export const    SURVEY_LINKED_FIELD = "This answer is linked directly to a profile field. Any information in that field will be mirrored here, and editing this information will edit your profile. Linked fields have a special icon: ";
export const    SURVEY_LINKED_FIELD1 = "Any field marked with (";
export const    SURVEY_LINKED_FIELD2 = ") is linked directly to a profile field. Any information from that field is mirrored here, and editing that information will edit your profile.";

//generic app wide
export const    NOT_IMPLEMENTED = "This feature is not yet implemented. Check back soon!";
export const    ADMIN_ADD_AGREEMENT_SUCCESS = (title) => `${title} successfully added to Planorama.`;
export const    ADMIN_ADD_USER_SUCCESS = (name) => `${name} successfully added to Planorama.`;
export const    ADMIN_ADD_USER_ERROR = (name) => errorMessage(`${name} failed to be added to Planorama.`);
export const    IEA_FAILURE_TO_SIGN = "As a member of Staff you can not proceed without agreeing to the ethics and data privacy statements.";
export const    MODEL_SAVE_SUCCESS = (model) => `${titleCase(model)} sucessfully saved.`;
export const    MODEL_SAVE_ERROR = (model) => errorMessage(`${titleCase(model)} failed to be saved.`);
export const    MODEL_ADD_SUCCESS = (model) => `${titleCase(model)} sucessfully added.`;
export const    MODEL_ADD_ERROR = (model) => errorMessage(`${$titleCase(model)} failed to be added.`);
export const    MODEL_DELETE_SUCCESS = (model) => `${titleCase(model)} sucessfully deleted.`;
export const    MODEL_DELETE_ERROR = (model) => errorMessage(`${titleCase(model)} failed to be deleted.`);
export const    MODEL_MASS_UPDATE_SUCCESS = (model) => `All ${titleCase(model)} sucessfully updated.`;
export const    MODEL_MASS_UPDATE_ERROR = (model) => errorMessage(`All ${titleCase(model)} failed to be updated.`);

// Mailing messages
export const    MAILING_SCHEDULED = (title) => `The mailing ${title} has been scheduled.`;
export const    MAILING_TEST_SCHEDULED = (title) => `A test of the mailing ${title} has been scheduled.`;
export const    MAILING_CLONED = (title) => `A clone of the mailing ${title} has been created.`;

//question actions
export const    QUESTION_ORDER_SAVE_SUCCESS = "Question reorder successfully saved.";
export const    QUESTION_ORDER_SAVE_ERROR = errorMessage("Question reorder failed to be saved.");
export const    QUESTION_SAVE_SUCCESS = "Question successfully saved.";
export const    QUESTION_SAVE_ERROR = errorMessage("Question failed to be saved.");
export const    QUESTION_DELETE_SUCCESS = "Question successfully deleted.";
export const    QUESTION_DELETE_ERROR = errorMessage("Question failed to be deleted.");
export const    QUESTION_DUPLICATE_SUCCESS = "Question successfully duplicated.";
export const    QUESTION_DUPLICATE_ERROR = errorMessage("Question failed to be duplicated.");
export const    QUESTION_ADD_SAVE_SUCCESS = "Question successfully added.";
export const    QUESTION_ADD_SAVE_ERROR = errorMessage("Question failed to be added.");
export const    QUESTION_UNCHANGED = "Question change abandoned.";
export const    QUESTION_MODAL_MESSAGE = "You are changing the question type and there's a linked field associated with that specific question type. If you continue with changing the question type, we will remove the linked field. You can choose to leave the question type as it is and the linking will remain.";

//answer actions
export const    ANSWER_ORDER_SAVE_SUCCESS = "Answer reorder sucessfully saved.";
export const    ANSWER_ORDER_SAVE_ERROR = errorMessage("Answer reorder failed to be saved.");
export const    ANSWER_SAVE_SUCCESS = "Answer sucessfully saved.";
export const    ANSWER_SAVE_ERROR = errorMessage("Answer failed to be saved.");
export const    ANSWER_ADD_SUCCESS = "Answer sucessfully added.";
export const    ANSWER_ADD_ERROR = errorMessage("Answer failed to be added.");

// session interest
export const    SESSION_INTEREST_SUCCESS = "Session Interest saved.";
export const    SESSION_INTEREST_ERROR = errorMessage("Session Interest failed to be saved.");
export const    SESSION_INTEREST_REMOVE_SUCCESS = "Session Interest removed.";
export const    SESSION_INTEREST_REMOVE_ERROR = errorMessage("Session Interest failed to be removed.");
export const    SESSION_ASSIGNMENT_SUCCESS = "Session Assignment saved.";
export const    SESSION_ASSIGNMENT_ERROR = errorMessage("Session Assignment failed to be saved.");
export const    SESSION_INTEREST_UPDATE_SUCCESS = "Session Interest updated.";
export const    SESSION_INTEREST_UPDATE_ERROR = errorMessage("Session Interest failed to be updated.");

export const    SESSION_SAVE_SUCCESS_DELETE = "Session successfully deleted.";
export const    SESSION_SAVE_ERROR_DELETE = errorMessage("Session failed to be deleted.");
export const    SESSION_SAVE_SUCCESS = "Session successfully saved.";
export const    SESSION_SAVE_ERROR = errorMessage("Session failed to be saved.");

export const    SESSION_RANKING_ERROR = (total, allowed) => `You have assigned ${total} which exceeds the allowed ${allowed}.`;

export const    CONFIGURATION_SAVED_SUCCESS = "Configuration has been saved.";
export const    CONFIGURATION_SAVED_ERROR = errorMessage("Error on config save.");

export const    CREATE_SESSION_LIMIT_SUCCESS = "Session limit has been saved.";
export const    CREATE_SESSION_LIMIT_ERROR = errorMessage("Error on session limit save.");
export const    SESSION_LIMIT_SAVE_SUCCESS = "Session Limit successfully saved.";

export const    AVAILABILITY_DESCRIPTION = "Under each day, please highlight (click and drag) the times you are available in the calendar view below.";
export const    SAVE_AVAILABILITY_NOTES = "Other scheduling considerations saved successfully.";
export const    AVAILABILITY_NOTES_LABEL = "Other Scheduling Considerations";

export const    UPDATE_PERSON_EXCLUSION_SUCCESS = "Exclusion information has been updated.";
export const    UPDATE_PERSON_EXCLUSION_ERROR = errorMessage("Error on updating exclusion information.");
export const    GET_PERSON_EXCLUSION_SUCCESS = "Exclusion information has been retrieved.";
export const    GET_PERSON_EXCLUSION_ERROR = errorMessage("Error on retrieving exclusion information.");

export const    UPDATE_AVAILABILITY_SUCCESS = "Availability has been updated.";
export const    UPDATE_AVAILABILITY_ERROR = errorMessage("Error on updating availability.");

export const    ADD_EMAIL_SUCCESS = "Email has been added.";
export const    ADD_EMAIL_ERROR = errorMessage("Error on add email.");

//page actions
export const    PAGE_DELETE_SUCCESS = "Page successfully deleted.";
export const    PAGE_DELETE_ERROR = errorMessage("Page failed to be deleted.");
export const    PAGE_MERGE_SUCCESS = "Page successfully merged.";
export const    PAGE_MERGE_ERROR = errorMessage("Page failed to be merged.");
export const    SURVEY_CONFIRM_DELETE_PAGE_1 = "Deleting a page also deletes the questions and response options it contains.";
export const    SURVEY_CONFIRM_DELETE_PAGE_2 = "To preserve the questions, choose \"Merge page up\" from the page options.";
export const    PAGE_ADD_SUCCESS = "Page successfully added.";
export const    PAGE_ADD_ERROR = errorMessage("Page failed to be added.");
export const    PAGE_SAVE_SUCCESS = "Page successfully saved.";
export const    PAGE_SAVE_ERROR = errorMessage("Page failed to be saved.");

//venues
export const    VENUES_ADD_ROOM_SUCCESS = (name) => `${name} successfully added.`;
export const    VENUES_ADD_ROOMSET_SUCCESS = (name) => `${name} successfully added.`;
export const    VENUES_ADD_VENUE_SUCCESS = (name) => `${name} successfully added.`;

// linked field names
export const    LINKED_FIELD_LABELS = {
        Person : {
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
            excluded_demographic_categories: "Demographic topics not to discuss",
            accommodations: "Accessibility details",
            moderation_experience: "Moderation experience",
            othered: "Othered?",
            indigenous: "Indigenous?",
            black_diaspora: "Black diaspora?",
            global_diaspora: "Global diaspora?",
            non_us_centric_perspectives: "Not US-centric?",
            non_anglophone: "Non-anglophone?",
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
            twitter: "X (formerly Twitter)",
            facebook: "Facebook",
            website: "Website",
            instagram: "Instagram",
            twitch: "Twitch",
            youtube: "YouTube",
            tiktok: "TikTok",
            linkedin: "LinkedIn",
            flickr: "Flickr",
            reddit: "Reddit",
            bsky: "Bluesky",
            fediverse: "Fediverse",
            othersocialmedia: "Other Social Media",
            socialmedia: "Social Media",
            can_share: "Permission to share email with participants"
        }
    };
// export nLines;

export const    ERROR_GENERIC_RECOVERABLE = (email) => twoLines("The server has encountered an internal error and was unable to complete your request.",
    `Please contact the server administrator at ${email} and let them know the time and date the error occurred.`);
export const    ERROR_GENERIC_UNRECOVERABLE = (email) => twoLines("The server has encountered an internal error and was unable to complete your request.",
    `Please contact the server administrator at ${email} and let them know the time and date the error occurred.`);

export const    ADD_CONFLICT_IGNORE_SUCCESS = "Ignore Conflict Added";
export const    ADD_CONFLICT_IGNORE_ERROR = "Ignore Conflict Failed";

// Social Links Errors
export const    TWITTER_ID_INVALID_MSG = "X (formerly Twitter) ID is not in a valid format";
export const    FACEBOOK_ID_INVALID_MSG = "Facebook ID is not in a valid format";
export const    WEBSITE_INVALID_MSG = "Website is not in a valid format";
export const    INSTAGRAM_ID_INVALID_MSG = "Instagram ID is not in a valid format";
export const    TWITCH_ID_INVALID_MSG = "Twitch ID is not in a valid format";
export const    YOUTUBE_ID_INVALID_MSG = "Youtube is not in a valid format";
export const    TIKTOK_ID_INVALID_MSG = "TikTok ID is not in a valid format";
export const    LINKEDIN_ID_INVALID_MSG = "LinkedIn ID is not in a valid format";
export const    PROFILE_FIELD_LABELS = {
        ethnicity: "Ethnicity",
        gender: "Gender",
        age_at_convention: "Age at time of event",
        romantic_sexual_orientation: "Romantic and/or sexual orientation",
        othered: "Experience with being \"othered\"",
        indigenous: "Member of an Indigenous community",
        black_diaspora: "Member of the global Black diaspora",
        non_us_centric_perspectives: "Represent something other than a purely US-centric perspective",
        demographic_categories: "Other demographic categories",
        twitter: "X (formerly Twitter)",
        facebook: "Facebook",
        website: "Website",
        instagram: "Instagram",
        twitch: "Twitch",
        youtube: "YouTube",
        tiktok: "TikTok",
        linkedin: "LinkedIn",
        flickr: "Flickr",
        reddit: "Reddit",
        bsky: "Bluesky",
        fediverse: "Fediverse",
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
        needs_accommodations: "Accessibility and/or disability concerns",
        accommodations: "Accessibility and/or disability details",
        registration_number: "Ticket Number",
        global_diaspora: "Member of the global diaspora",
        non_anglophone: "Represent something other than a purely anglophone perspective",
        excluded_demographic_categories: "Participant's demographic categories that should not be discussed on panels that include them",
        registered: "Registered",
        registration_type: "Registration Type",
        reg_attending_status: "Registration Attending Status"
};
export const    PERSON_SAVE_SUCCESS = "Profile record saved successfully";
export const    PERSON_NEVER_LOGGED_IN = "Never logged in";
export const    PERSON_DISABLED_LINK = "You can only link your own registration";
export const    PERSON_DISABLED_UNLINK = "You can only unlink your own registration";
export const    PERSON_UNLINK_SUCCESS = "Your registration account has been unlinked.";
export const    PERSON_UNLINK_FAILURE = errorMessage("Something went wrong while unlinking your registration account.");
export const    PERSON_RESYNC_SUCCESS = "The Person sync has succeeded.";
export const    PERSON_RESYNC_FAILURE = errorMessage("Something went wrong while resyncing the person.");
export const    PERSON_UNLINK_CONFIRMATION_1 = "This will unlink your registration account from your Planorama account. It will not remove your data from other convention systems.";
export const    PERSON_UNLINK_CONFIRMATION_2 = "Are you sure you want to do this action?";
export const    PERSON_CON_STATE = {
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
    };
export const    PERSON_ATTENDANCE_TYPE = {
        in_person: "In Person",
        hybrid: "In Person AND Online",
        virtual: "Online"
    };

export const    PAGE_CONTENT_SAVE_SUCCESS = "Page content saved successfully";
export const    PAGE_CONTENT_SAVE_ERROR = "Page content save failed";
export const    PAGE_CONTENT_SUCCESS_DELETE = "Page content successfully deleted.";
export const    PAGE_CONTENT_ERROR_DELETE = errorMessage("Page content failed to be deleted.");

export const    SURVEY_REDIRECT = "Unfortunately due to the browser refreshing we have lost any answers you filled in. Please fill the survey out again.";
export const    SURVEY_PUBLIC_NO_EDIT = "You cannot edit a published survey. Close the survey to enable editing.";
export const    SURVEY_PUBLIC_NO_DELETE = "You cannot delete a published survey. Close the survey to enable deletion.";
export const    SESSION_ENVIRONMENT = {
        unknown: "Unknown",
        in_person: "In Person",
        hybrid: "Hybrid",
        virtual: "Online"
    };
export const    SESSION_STATUS = {
        draft: "Draft",
        reviewed: "Reviewed",
        revised: "Revised",
        dropped: "Dropped"
    };
export const    SESSION_NO_TAGS = (tagName) => `Click the pencil to add ${tagName}`;
export const    SESSION_MUST_UNSCHEDULE = "You must unschedule a session before dropping it";
export const    SESSION_MUST_UNDROP = "You must un-drop the session to be able to schedule it.";
export const    SESSION_MINORS_PARTICIPATION = {
        kids_observe: "Kids welcome to observe",
        kids_supervision: "Kids welcome to participate with supervision",
        kids_participate: "Kids welcome to participate",
        geared_families: "Geared towards families",
        geared_kids: "Geared towards kids"
    };
export const    SCHEDULE_DRAFT_CONFIRM_MESSAGE = "This will publish a Draft Schedule to all participants, who will see their own sessions.  This action is irreversible and will bring the server down for a short time. Please double check that you wish to perform this action.";
export const    SCHEDULE_FIRM_CONFIRM_MESSAGE = "This will publish a Firm Schedule to all participants, who will see their own sessions - live.  This action is irreversible. Please double check that you wish to perform this action.";
export const    SCHEDULE_DRAFT_SUCCESS_MESSAGE = "Draft schedule has been published successfully";
export const    SCHEDULE_FIRM_SUCCESS_MESSAGE = "Firm schedule has been published successfully";
export const    SCHEDULE_APPROVAL_FAIL_TO_LOAD = "Couldn't load the approval form. Try again soon.";
// The below is intended to become a way to override defaults in the model mixin easily. Hasn't happened yet though.
export const    SPECIFIC_MODEL_SAVE_SUCCESS = {
        person_schedule_approval: {
            person_schedule_approval: "Schedule approval saved.",
            approved: (approvalType) => `${titleCase(approvalType)} approval was successfully saved.`,
            comments: (approvalType) => `${titleCase(approvalType)} approval comment was successfully saved.`
        }
    };
export const    SPECIFIC_MODEL_SAVE_ERROR = {
        person_schedule_approval: {
            person_schedule_approval: errorMessage("Schedule approval was not saved."),
            approved: (approvalType) => errorMessage(`${titleCase(approvalType)} approval was not saved.`),
            comments: (approvalType) => errorMessage(`${titleCase(approvalType)} approval comment was not saved.`)
        }
    };
export const    EVENT_SETTINGS_MUST_RELOAD = "*** Changes to these settings will only take effect after you reload your browser page. ***";
export const    CONFIGURATION_LABEL_OVERRIDES = {
        event_virtual: "Does this event include an online component?",
        clyde_base_url: "Base URL for Clyde",
        profile_show_info_demographic_community: "Show Demographics, Community, and Info in Profile"
    };
export const    PROFILE_LINK_EXPLAINATION_1 = "When you link your Planorama account to your registration account they are matched, and you will be asked to confirm the correct registration account.";
export const    PROFILE_LINK_EXPLAINATION_2 = "You will continue to log in to Planorama using the password you created, not your registration login details.";
export const    PROFILE_LINK_EXPLAINATION_TITLE = "What does it mean to link to registration?";
export const    REG_ID_SEARCH_PLACEHOLDER = "Search for a ticket number.";
export const    REG_ID_FOUND = "Found a match in the registration database";
export const    REG_ID_NOT_FOUND = "No results found. Please check your input.";
export const    REG_ID_UNLINK_BUTTON = "Unlink Current Registration";
export const    REG_ID_UNLINK_CONFIRMATION_TITLE = "";

