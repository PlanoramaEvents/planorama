const twoLines = (line1, line2) => (h) =>  h('p', {}, [line1, h('br'), line2]);
const titleCase = (model) => `${model.substring(0, 1).toUpperCase()}${model.substring(1)}`

module.exports = {
    // login page
    LOGIN_401: "You have entered an incorrect username or password.",
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
    LOGIN_CLICK_TO_AGREE: "By clicking ‘Log In’ below, I agree to Chicon 8 storing and using my personal data as documented in the",
        
    // toast titles
    ERROR_TOAST_TITLE: "Error",
    SUCCESS_TOAST_TITLE: "Success",
    
    //survey actions
    SURVEY_SAVE_SUCCESS: "Survey successfully saved.",
    SURVEY_SAVE_ERROR: (errorCode) => `Survey failed to be saved. \nError code: ${errorCode}`,
    SURVEY_CONFIRM_PUBLISH: "You are about to publish this survey. This will make the survey visible to the public and allow responses to be collected. Are you sure you want to publish this survey?",
    SURVEY_CONFIRM_CLOSE: "You are about to close this survey. This will no longer allow any responses to be collected. Are you sure you want to close this survey?",
    SURVEY_CONFIRM_DELETE: "Are you sure you want to permanently delete this survey? This cannot be undone.",
    SURVEY_SAVE_SUCCESS_PUBLISH: "Survey successfully published.",
    SURVEY_SAVE_ERROR_PUBLISH: (errorCode) => `Survey failed to be published. \nError code: ${errorCode}`,
    SURVEY_SAVE_SUCCESS_CLOSE: "Survey successfully closed.",
    SURVEY_SAVE_ERROR_CLOSE: (errorCode) => `Survey failed to be closed. \nError code: ${errorCode}`,
    SURVEY_SAVE_SUCCESS_DELETE: "Survey successfully deleted.",
    SURVEY_SAVE_ERROR_DELETE: (errorCode) => `Survey failed to be deleted. \nError code: ${errorCode}`,
    SURVEY_SAVE_SUCCESS_ADD: "Survey successfully added.",
    SURVEY_SAVE_ERROR_ADD: (errorCode) => `Survey failed to be added. \nError code: ${errorCode}`,
    
    // survey results actions
    SURVEY_RESULTS_CLEAR_SUCCESS: "Results successfully cleared.",
    SURVEY_RESULTS_CLEAR_ERROR: (errorCode) => `Results failed to be cleared. \nError code: ${errorCode}`,
    SURVEY_RESULTS_CLEAR_CONFIRM: "This will permanently delete all responses to this survey. Are you sure you wish to clear all responses?",
    SURVEY_RESULTS_FREEZE_SUCCESS: "Response edits successfully frozen.",
    SURVEY_RESULTS_FREEZE_ERROR: (errorCode) => `Response edits failed to be frozen. \nError code: ${errorCode}`,
    SURVEY_RESULTS_UNFREEZE_SUCCESS: "Response edits successfully unfrozen.",
    SURVEY_RESULTS_UNFREEZE_ERROR: (errorCode) => `Response edits failed to be unfrozen. \nError code: ${errorCode}`,
    
    //survey defaults
    SURVEY_DEFAULT_THANK_YOU: "Your responses have been recorded.",
    
    //generic app wide 
    NOT_IMPLEMENTED: "This feature is not yet implemented. Check back soon!",
    ADMIN_ADD_USER_SUCCESS: (name) => `${name} successfully added to Planorama.`,
    ADMIN_ADD_USER_ERROR: (name) => `${name} failed to be added to Planorama.`,
    IEA_FAILURE_TO_SIGN: "As a member of Staff you can not proceed without agreeing to the ethics and data privacy statments.",   
    MODEL_SAVE_SUCCESS: (model) => `${titleCase(model)} sucessfully saved.`,
    MODEL_SAVE_ERROR: (model) => (errorCode) => twoLines(`${model.substring(0, 1).toUpperCase()}${model.substring(1)} failed to be saved.`, `Error code: ${errorCode}`),
    MODEL_ADD_SUCCESS: (model) => `${model.substring(0, 1).toUpperCase()}${model.substring(1)} sucessfully added.`,
    MODEL_ADD_ERROR: (model) => (errorCode) => `${model.substring(0, 1).toUpperCase()}${model.substring(1)} failed to be added.\nError code: ${errorCode}`,
    MODEL_DELETE_SUCCESS: (model) => `${model.substring(0, 1).toUpperCase()}${model.substring(1)} sucessfully deleted.`,
    MODEL_DELETE_ERROR: (model) => (errorCode) => `${model.substring(0, 1).toUpperCase()}${model.substring(1)} failed to be deleted.\nError code: ${errorCode}`,
   
    
    
    //question actions
    QUESTION_ORDER_SAVE_SUCCESS: "Question reorder successfully saved",
    QUESTION_ORDER_SAVE_ERROR: (errorCode) => `Question reorder failed to be saved. \nError code: ${errorCode}`,
    QUESTION_SAVE_SUCCESS: "Question successfully saved",
    QUESTION_SAVE_ERROR: (errorCode) => `Question failed to be saved. \nError code: ${errorCode}`,
    QUESTION_DELETE_SUCCESS: "Question successfully deleted",
    QUESTION_DELETE_ERROR: (errorCode) => `Question failed to be deleted. \nError code: ${errorCode}`,
    QUESTION_DUPLICATE_SUCCESS: "Question successfully duplicated",
    QUESTION_DUPLICATE_ERROR: (errorCode) => twoLines('Question failed to be duplicated.', `Error code: ${errorCode}`),
    QUESTION_ADD_SAVE_SUCCESS: "Question successfully added",
    QUESTION_ADD_SAVE_ERROR: (errorCode) => `Question failed to be added. \nError code: ${errorCode}`,
    
    //answer actions
    ANSWER_ORDER_SAVE_SUCCESS: "Answer reorder sucessfully saved",
    ANSWER_ORDER_SAVE_ERROR: (errorCode) => `Answer reorder failed to be saved. \nError code: ${errorCode}`,
    ANSWER_SAVE_SUCCESS: "Answer sucessfully saved",
    ANSWER_SAVE_ERROR: (errorCode) => `Answer failed to be saved. \nError code: ${errorCode}`,
    ANSWER_ADD_SUCCESS: "Answer sucessfully added",
    ANSWER_ADD_ERROR: (errorCode) => `Answer failed to be added. \nError code: ${errorCode}`,
    
    //page actions 
    PAGE_DELETE_SUCCESS: "Page successfully deleted",
    PAGE_DELETE_ERROR: (errorCode) => `Page failed to be deleted. \nError code: ${errorCode}`,
    PAGE_MERGE_SUCCESS: "Page successfully merged",
    PAGE_MERGE_ERROR: (errorCode) => `Page failed to be merged. \nError code: ${errorCode}`,
    SURVEY_CONFIRM_DELETE_PAGE_1: "Deleting a page also deletes the questions and response options it contains.",
    SURVEY_CONFIRM_DELETE_PAGE_2: "To preserve the questions, choose \"Merge page up\" from the page options.",
    PAGE_ADD_SUCCESS: "Page successfully added",
    PAGE_ADD_ERROR: (errorCode) => `Page failed to be added. \nError code: ${errorCode}`,

    
}
