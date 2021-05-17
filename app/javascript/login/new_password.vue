<template>
  <div class="new-password">
    <h3>Reset Password</h3>
    <p>In order to protect your account, make sure your password:</p>
    <ul>
      <li>Is 6 or more characters</li>
      <li>Does not contain the word "password"</li>
      <li>Does not contain your email address</li>
      <li>Is not one of your most recent passwords</li>
      <li>Is not a member of this <a>TODO list of common passwords TODO</a></li>
    </ul>
    <p>
      Optionally, we recommend you follow the
      <a>TODO Correct Horse Battery Staple TODO</a> paradigm.
    </p>
    <b-form @submit="onSubmit">
      <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
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
        <b-button type="submit" variant="primary" class="px-5">Change Password</b-button>
      </div>
    </b-form>
  </div>
</template>

<script>
import { http } from "../http";
import { LOGIN_MISSING_NEW_PASSWORD, LOGIN_PASSWORDS_MUST_MATCH, LOGIN_PASSWORD_INVALID, SOMETHING_WENT_WRONG } from "../constants/errors";
import LoginPasswordField from "./login_password_field";
import { validateFields } from '../utils';

export default {
  name: "NewPassword",
  components: {
    LoginPasswordField,
  },
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
        validate: null
      },
      passwordConfirmation: {
        valid: null,
        validate: null
      },
    },
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
        if(this.person.password.length < 1) {
          this.error.text = LOGIN_MISSING_NEW_PASSWORD;
        } else if(this.form.password.valid === false) {
          this.error.text = LOGIN_PASSWORD_INVALID;
        } else {
          this.error.text = LOGIN_PASSWORDS_MUST_MATCH;
        }
        this.error.visible = true;
      } else {
        http
          .put("/people/password.json", { person: this.person })
          .then((data) => {
            if (data.status === 204) {
              this.$router.push("/");
            } else {
              console.log(data);
              this.error.text = SOMETHING_WENT_WRONG;
              this.error.visible = true;
            }
          })
          .catch((error, result) => {
            if (error.response.data.errors) {
              console.log(
                error.response.data.errors,
                "needs to show instead TODO"
              );
            }
            this.error.text = SOMETHING_WENT_WRONG;
            this.error.visible = true;
          });
      }
    },
  },
};
</script>
