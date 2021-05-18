module.exports = {
    // login page
    LOGIN_401: "You have an incorrect username or password.",
    LOGIN_MISSING_PASSWORD: "You must enter a password.",
    LOGIN_INVALID_FIELDS: "You must provide all of your login information.",
    LOGIN_MISSING_EMAIL: "You must enter an email address.",
    LOGIN_NOT_AN_EMAIL: "Email address needs to be in the correct format e.g. xyz@test.com",
    LOGIN_SHORT_PASSWORD: "Your password must be at least 6 characters long.",
    LOGIN_PASSWORDS_DO_NOT_MATCH: "Your passwords do not match.",
    SOMETHING_WENT_WRONG: (helpEmail) => `Oops, something went wrong on our end. Please try again in a few minutes or contact us at ${helpEmail} if the problem persists.`,
    LOGIN_MISSING_NEW_PASSWORD: "You must enter a new password.",
    LOGIN_PASSWORDS_MUST_MATCH: "Your passwords must match.",
    LOGIN_PASSWORD_INVALID: "Your new password must meet the security criteria.",
    LOGIN_PASSWORD_RESET_EMAIL_SEND: "If an account with the address you specified exists you will receive an email with a password reset link.",
    LOGIN_PASSWORD_CHANGED: "You successfully changed your password.",
    LOGIN_TOKEN_EXPIRED: (resetPasswordLink) => `The password reset link you used is no longer valid. Please request another link here: ${resetPasswordLink}`,
}
