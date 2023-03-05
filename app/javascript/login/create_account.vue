<template>
  <div class="new-account">
    <h3>Create Account</h3>
    <p>
      Enter your email address below to either create an account or reset your
      password.
    </p>
    <p>
      If an account with this address exists, you will receive an email with a
      link to complete the password process. If one does not, you will receive a
      link to create your account.
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
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "CreateAccount",
  mixins: [settingsMixin],
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
        // TODO: we need the URL of the destination if any that the user is going to be sent to
        // This would, for example, be the survey
        let destination = "http://localhost:3000/#/people";

        http
          // TODO REPLACE ME with correct endpoint
          .post("/login/sign_up", { email: this.person.email, url: destination })
          .then((data) => {
            console.debug("***** created ", data)
            this.successfullySent = data.status === 201;
            if (this.successfullySent) {
              this.$router.push("/?alert=reset_sent");
            } else {
              this.alert.text = SOMETHING_WENT_WRONG(
                this.configByName("email_reply_to_address")
              );
              this.alert.visible = true;
            }
          })
          .catch((error) => {
            // this.alert.text = SOMETHING_WENT_WRONG(this.configByName('email_reply_to_address'));
            // this.alert.visible = true;
            // Even if we have a problem we need to pretend that we do not
            this.$router.push("/?alert=reset_sent");
          });
      }
    },
  },
};
</script>
