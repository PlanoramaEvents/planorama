<template>
  <div class="login">
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
      ></login-password-field>
      <div class="pt-3"><small>{{LOGIN_CLICK_TO_AGREE}} <privacy-policy-link></privacy-policy-link>.</small></div>
      <div class="d-flex flex-row-reverse mb-3">
        <router-link to="/login/forgot">Forgot Password?</router-link>
      </div>
      <div class="d-flex flex-row-reverse">
        <b-button type="submit" variant="primary" class="px-5">Log In</b-button>
      </div>
    </b-form>
    <!--iea-modal @cancel="onIeaCancel" @ok="onIeaAgree"></iea-modal-->
    <div class="d-flex mb-3">
      <router-link to="/login/forgot">Never set up your password? Set it up now</router-link>
    </div>
  </div>
</template>

<script>
import EmailField from "@/shared/email_field";
import LoginPasswordField from "./login_password_field";
import PrivacyPolicyLink from "@/administration/privacy_policy_link"
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
    IeaModal,
  },
  mixins: [authMixin, personSessionMixin, settingsMixin],
  computed: {
    conventionName() {
      return this.configByName('convention_name') || ''
    },
    LOGIN_CLICK_TO_AGREE() {
      return LOGIN_CLICK_TO_AGREE(this.conventionName);
    }
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
