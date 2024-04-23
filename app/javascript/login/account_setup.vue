<template>
  <div>
    <header class="d-flex justify-content-between align-items-baseline">
      <h3>Utwórz Konto</h3>
      <h5>Dla adresu e-mail: {{ currentUserEmail }}</h5>
    </header>

    <b-form @submit="onSubmit">
      <b-alert
        :show="error.visible"
        variant="danger"
        v-html="error.text"
      ></b-alert>
      <name-field
        v-model="person.name"
        @validated="form.name.valid = $event"
        :validateNow="form.name.validate"
        :required="true"
      ></name-field>
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
      <pw-requirements></pw-requirements>
      <div class="d-flex flex-row-reverse">
        <b-button type="submit" variant="primary" class="px-5"
          >Utwórz Konto</b-button
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
} from "@/constants/strings";
import LoginPasswordField from "./login_password_field";
import { validateFields } from "@/utils";
import settingsMixin from "@/store/settings.mixin";
import NameField from "@/shared/name_field.vue";
import { personSessionMixin } from "@/mixins";
import PwRequirements from './pw_requirements.vue';

export default {
  name: "AccountSetup",
  components: {
    LoginPasswordField,
    NameField,
    PwRequirements,
  },
  mixins: [settingsMixin, personSessionMixin],
  data: () => ({
    person: {
      password: "",
      password_confirmation: "",
      name: "",
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
      name: {
        valid: null,
        validate: null,
      },
    },
    resetPasswordLink: `<a href="/#/login/forgot">Zresetuj Hasło</a>`,
  }),
  methods: {
    // TODO: add code to enforce password security
    onSubmit: async function (event) {
      event.preventDefault();
      await validateFields(
        this.form.password,
        this.form.passwordConfirmation,
        this.form.name
      );
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
      } else if (this.form.name.valid === false) {
        this.error.text = NAME_MISSING;
        this.error.visible = true;
      } else {
        http
          .put("/login/complete_sign_up", { person: this.person })
          .then((data) => {
            // The server will send back a 303 redirect
            if (data.status === 200) {
              // console.debug("SIGN UP COMPLETED", data.data.redirect)
              // Need to refetch the person
              this.fetchSession({force: true}).then(
                () => {
                  // NOTE: need this cause redirect is a full URL not a router path
                  window.location.href = data.data.redirect;
                }
              )
            } else {
              this.error.text = SOMETHING_WENT_WRONG(
                this.configByName("email_reply_to_address")
              );
              this.error.visible = true;
            }
          })
          .catch((error, result) => {
            const errors = error.response.data.errors;
            if (
              errors &&
              errors.reset_password_token[0] ===
                "has expired, please request a new one"
            ) {
              this.error.text = LOGIN_TOKEN_EXPIRED(this.resetPasswordLink);
            } else if (
              errors &&
              errors.reset_password_token[0] === "is invalid"
            ) {
              this.error.text = LOGIN_TOKEN_EXPIRED(this.resetPasswordLink);
            } else {
              this.error.text = SOMETHING_WENT_WRONG(
                this.configByName("email_reply_to_address")
              );
            }
            this.error.visible = true;
          });
      }
    },
  },
};
</script>
