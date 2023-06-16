<template>
  <div class="login">
    <div class="py-2"><small>{{LOGIN_CLICK_TO_AGREE}} <privacy-policy-link></privacy-policy-link>.</small></div>
    <login-integrations></login-integrations>
    <b-alert :show="alert.visible" variant="success" dismissible>{{
      alert.text
    }}</b-alert>
    <b-alert :show="error.visible" variant="danger">{{ error.text }}</b-alert>
    <b-form @submit="onSubmit">
      <email-field
        v-model="person.email"
        @validated="form.email.valid = $event"
        :validateNow="form.email.validate"
      ></email-field>
      <login-password-field
        v-model="person.password"
        @validated="form.password.valid = $event"
        :validateNow="form.password.validate"
        :validation="false"
      ></login-password-field>
      <div class="d-flex flex-row-reverse mb-3">
        <router-link :to="'/login/forgot?redirect=' + redirect">Forgot Password?</router-link>
      </div>
      <div class="d-flex flex-row-reverse">
        <b-button type="submit" variant="primary" class="px-5">Log In</b-button>
      </div>
    </b-form>
    <!--iea-modal @cancel="onIeaCancel" @ok="onIeaAgree"></iea-modal-->
    <div class="d-flex flex-column mb-3">
      <router-link :to="'/login/forgot?redirect=' + redirect">Never set up your password? Set it up now</router-link>
      <router-link :to="'/login/new?redirect=' + redirect">Create account</router-link>
    </div>
  </div>
</template>

<script>
import EmailField from "@/shared/email_field.vue";
import LoginPasswordField from "./login_password_field.vue";
import PrivacyPolicyLink from "@/administration/privacy_policy_link.vue"
import LoginIntegrations from "./login_integrations.vue";
import IeaModal from './iea-modal';
import axios from 'axios';
import {
  authMixin,
  personSessionMixin
} from '@mixins';

import { validateFields } from "@/utils";

import {
  LOGIN_401,
  LOGIN_MISSING_PASSWORD,
  LOGIN_INVALID_FIELDS,
  LOGIN_PASSWORD_RESET_EMAIL_SEND,
  LOGIN_PASSWORD_CHANGED,
  LOGIN_CLICK_TO_AGREE,
  IEA_FAILURE_TO_SIGN
} from "@/constants/strings";
import { settingsMixin } from "@/mixins";


export default {
  name: "PlanLogin",
  props: ['redirect'],
  data() {
    return {
      person: {
        email: "",
        password: "",
      },
      error: {
        visible: false,
        text: "",
      },
      alert: {
        visible: false,
        text: "",
      },
      form: {
        email: {
          valid: null,
          validate: null,
        },
        password: {
          valid: null,
          validate: null,
        },
      },
    };
  },
  components: {
    EmailField,
    LoginPasswordField,
    PrivacyPolicyLink,
    LoginIntegrations,
    IeaModal,
  },
  mixins: [authMixin, personSessionMixin, settingsMixin],
  computed: {
    conventionName() {
      return this.configByName('convention_name') || ''
    },
    LOGIN_CLICK_TO_AGREE() {
      return LOGIN_CLICK_TO_AGREE(this.conventionName);
    },
  },
  mounted: function () {
    if (this.$route.query.alert) {
      switch (this.$route.query.alert) {
        case "reset_sent":
          this.alert.text = LOGIN_PASSWORD_RESET_EMAIL_SEND;
          this.alert.visible = true;
          break;
        case "password_changed":
          this.alert.text = LOGIN_PASSWORD_CHANGED;
          this.alert.visible = true;
          break;
        default:
          this.alert.visible = false;
      }
    }
  },
  methods: {
    onSubmit(event) {
      event.preventDefault();
      // It sure seems like we're validating password here. but we're not
      // however if we don't go through the validation process, the form won't submit
      // it is skipping the actual validation internally though
      validateFields(this.form.email, this.form.password).then(() => {
        if (
          this.form.email.valid === false ||
          this.form.password.valid === false
        ) {
          this.error.text = LOGIN_INVALID_FIELDS;
          this.error.visible = true;
        } else {
          axios.post('/auth/sign_in', {person: this.person})
            .then(() => this.$bvModal.show('iea-modal'))
            .then(() => this.fetchSession())
            .catch((error) => this.onSaveFailure(error));
        }
      })
    },
    onSaveFailure: function (error) {
      this.error.text = error.message;
      if (error.message === "Request failed with status code 401") {
        this.error.text = LOGIN_401;
      }
      this.error.visible = true;
    },
    onIeaAgree() {
      window.location.href = "#"
    },
    onIeaCancel() {
      this.signOut().finally(() => {
        this.error.text = IEA_FAILURE_TO_SIGN;
        this.error.visible = true;
      })
    }
  },
};
</script>

<style lang="scss" scoped>
.lines-around::after,
.lines-around::before {
  content: "";
  flex: 1 1 0%;
  border-bottom: 1px solid black;
}

.lines-around::before {
  margin-right: 0.5rem;
}

.lines-around::after {
  margin-left: 0.5rem;
}
</style>
