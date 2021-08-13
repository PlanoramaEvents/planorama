<template>
  <div class="forgot-password">
    <h3>Reset Password</h3>
    <p>Don't worry, this happens to the best of us.</p>
    <p>
      If an account with this address exists, you will recieve an email with a
      link to complete the password reset process.
    </p>
    <b-alert :show="alert.visible" :variant="alert.variant">{{
      alert.text
    }}</b-alert>
    <b-form @submit="onSubmit">
      <email-field
        v-model="person.email"
        @validated="form.email.valid = $event"
        :validateNow="form.email.validate"
      ></email-field>
      <div class="d-flex flex-row-reverse">
        <b-button
          :disabled="submitDisabled"
          type="submit"
          variant="primary"
          class="px-5"
          >Send me a link</b-button
        >
      </div>
    </b-form>
  </div>
</template>

<script>
import EmailField from "../shared/email_field";
import { http } from "../http";
import { validateFields } from "../utils";
import {
  LOGIN_INVALID_FIELDS,
  SOMETHING_WENT_WRONG,
} from "../constants/strings";

export default {
  name: "ForgotPassword",
  data: () => ({
    person: {
      email: "",
    },
    alert: {
      variant: "danger",
      visible: false,
      text: "",
    },
    successfullySent: false,
    form: {
      email: {
        valid: null,
        validate: null,
      },
    },
    helpEmail: "configurable@email.com",
  }),
  components: {
    EmailField,
  },
  computed: {
    submitDisabled: function () {
      return this.form.email.valid === false;
    },
  },
  methods: {
    onSubmit: async function (event) {
      event.preventDefault();
      await validateFields(this.form.email);
      if (this.form.email.valid === false) {
        this.error.text = LOGIN_INVALID_FIELDS;
        this.error.visible = true;
      } else {
        http
          .post("/auth/password.json", { person: this.person })
          .then((data) => {
            this.successfullySent = data.status === 201;
            if (this.successfullySent) {
              this.$router.push("/?alert=reset_sent");
            } else {
              this.alert.text = SOMETHING_WENT_WRONG(this.helpEmail);
              this.alert.visible = true;
            }
          })
          .catch((error) => {
            this.alert.text = SOMETHING_WENT_WRONG(this.helpEmail);
            this.alert.visible = true;
          });
      }
    },
  },
};
</script>
