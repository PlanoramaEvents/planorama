<template>
  <div class="forgot-password">
    <h3>Ustaw/Resetuj Hasło</h3>
    <p>Nie martw się, to zdarza się nawet najlepszym z nas.</p>
    <p>
      Jeśli istnieje konto powiązane z tym adresem e-mail, otrzymasz e-mail z
      linkiem umożliwiającym zresetowanie hasła.
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
          >Wyślij mi link</b-button
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
  name: "ForgotPassword",
  mixins: [settingsMixin],
  props: ['redirect'],
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
    }
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
          .post("/auth/password.json", { person: this.person, redirect: this.redirect })
          .then((data) => {
            this.successfullySent = data.status === 201;
            if (this.successfullySent) {
              this.$router.push("/?alert=reset_sent");
            } else {
              this.alert.text = SOMETHING_WENT_WRONG(this.configByName('email_reply_to_address'));
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
  }
};
</script>
