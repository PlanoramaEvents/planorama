<template>
  <div class="new-password">
    <h3>Reset Password</h3>
    <pw-requirements></pw-requirements>
    <b-form @submit="onSubmit">
      <b-alert
        :show="error.visible"
        variant="danger"
        v-html="error.text"
      ></b-alert>
      <login-password-field
        v-model="person.password"
        :new-password="true"
        @validated="form.password.valid = $event"
        :validateNow="form.password.validate"
      ></login-password-field>
      <login-password-field
        v-model="person.password_confirmation"
        :confirmation="true"
        :must-match="person.password"
        @validated="form.passwordConfirmation.valid = $event"
        :validateNow="form.passwordConfirmation.validate"
      ></login-password-field>
      <div class="d-flex flex-row-reverse">
        <b-button type="submit" variant="primary" class="px-5"
          >Change Password</b-button
        >
      </div>
    </b-form>
  </div>
</template>

<script>
import { http } from "@/http";
import {
  LOGIN_MISSING_NEW_PASSWORD,
  LOGIN_PASSWORDS_MUST_MATCH,
  LOGIN_TOKEN_EXPIRED,
  SOMETHING_WENT_WRONG,
  PASSWORDS_MUST_NOT_BE_RECENT
} from "@/constants/strings";
import LoginPasswordField from "./login_password_field.vue";
import PwRequirements from './pw_requirements.vue';
import { validateFields } from "@/utils";
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "NewPassword",
  components: {
    LoginPasswordField,
    PwRequirements
  },
  mixins: [
    settingsMixin
  ],
  props: ['redirect'],
  data: () => ({
    person: {
      password: "",
      password_confirmation: "",
      reset_password_token: "",
    },
    error: {
      visible: false,
      text: "",
    },
    form: {
      password: {
        valid: null,
        validate: null,
      },
      passwordConfirmation: {
        valid: null,
        validate: null,
      },
    },
    resetPasswordLink: `<a href="/#/login/forgot">Reset Password</a>`,
  }),
  mounted: function () {
    this.person.reset_password_token = this.$route.query.reset_password_token;
  },
  methods: {
    onSubmit: async function (event) {
      event.preventDefault();
      await validateFields(this.form.password, this.form.passwordConfirmation);
      if (
        this.form.password.valid === false ||
        this.form.passwordConfirmation.valid === false
      ) {
        if (this.person.password.length < 1) {
          this.error.text = LOGIN_MISSING_NEW_PASSWORD;
        } else if (this.form.password.valid === false) {
          this.error.text = LOGIN_PASSWORD_INVALID;
        } else {
          this.error.text = LOGIN_PASSWORDS_MUST_MATCH;
        }
        this.error.visible = true;
      } else {
        http
          .put("/auth/password.json", { person: this.person })
          .then((data) => {
            if (data.status === 204) {
              if (this.redirect ) {
                this.$router.push(`/login?redirect=${this.redirect}`)
              } else {
                this.$router.push("/?alert=password_changed");
              }
            } else {
              this.error.text = SOMETHING_WENT_WRONG(this.configByName('email_reply_to_address'));
              this.error.visible = true;
            }
          })
          .catch((error, result) => {
            const errors = error.response.data.errors;
            if (errors && errors.reset_password_token && errors.reset_password_token[0] === "has expired, please request a new one") {
              this.error.text = LOGIN_TOKEN_EXPIRED(this.resetPasswordLink);
            } else if (errors && errors.reset_password_token && errors.reset_password_token[0] === "is invalid") {
              this.error.text = LOGIN_TOKEN_EXPIRED(this.resetPasswordLink);
            } else if (errors && errors.password[0] == "password was used in the past." ) {
              // Usually will not get here as the password is chack in JS which checkpassword
              // but this is a just in case
              this.error.text = PASSWORDS_MUST_NOT_BE_RECENT;
            } else {
              this.error.text = SOMETHING_WENT_WRONG(this.configByName('email_reply_to_address'));
            }
            this.error.visible = true;
          });
      }
    },
  },
};
</script>
