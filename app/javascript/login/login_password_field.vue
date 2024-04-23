<template>
  <b-form-group
    :id="formGroupId"
    :label="passwordLabel"
    :label-for="formInputId"
    :invalid-feedback="invalidMessage"
    :state="valid"
    :description="passwordDescription"
  >
    <b-form-input
      :id="formInputId"
      type="password"
      novalidate
      :value="value"
      @input="$emit('input', $event)"
      :state="valid"
      @focus="onPasswordFocus"
      @blur="onPasswordUnfocus"
    ></b-form-input>
  </b-form-group>
</template>

<script>
import { http } from "../http";
import {
  LOGIN_MISSING_PASSWORD,
  LOGIN_PASSWORDS_DO_NOT_MATCH,
  LOGIN_SHORT_PASSWORD,
  LOGIN_PASSWORD_UNSECURE
} from "@/constants/strings";

export default {
  name: "LoginPasswordField",
  props: {
    value: {
      type: String,
    },
    mustMatch: {
      type: String,
      default: "",
    },
    newPassword: {
      type: Boolean,
      default: false,
    },
    confirmation: {
      type: Boolean,
      default: false,
    },
    validateNow: {
      type: Function,
    },
    validation: {
      type: Boolean,
      default: true
    }
  },
  data: () => ({
    valid: null,
    passSecurityNeeds: false
  }),
  computed: {
    formInputId: function () {
      if (this.newPassword) {
        return "input-new-password";
      }
      if (this.confirmation) {
        return "input-confirm-password";
      }
      return "input-password";
    },
    formGroupId: function () {
      if (this.newPassword) {
        return "input-group-new-password";
      }
      if (this.confirmation) {
        return "input-group-confirm-password";
      }
      return "input-group-password";
    },
    invalidMessage: function () {
      if (this.value.length < 1 || (!this.newPassword && !this.confirmation)) {
        return LOGIN_MISSING_PASSWORD;
      }
      if (!this.passSecurityNeeds && !this.confirmation) {
        return LOGIN_PASSWORD_UNSECURE;
      }
      if (this.confirmation) {
        return LOGIN_PASSWORDS_DO_NOT_MATCH;
      }
      return LOGIN_SHORT_PASSWORD;
    },
    passwordLabel: function () {
      if (this.newPassword) {
        return "Nowe hasło";
      }
      if (this.confirmation) {
        return "Powtórz nowe hasło";
      }
      return "Hasło";
    },
    passwordDescription: function () {
      if (!this.newPassword && !this.confirmation) {
        return "Hasła muszą zawierać co najmniej: 6 znaków. Hasło nie może zawierać słowa 'hasło' ani nazwy użytkownika";
      }
      return "";
    },
  },
  watch: {
    validateNow: function (val) {
      this.validate();
      val(true);
    },
  },
  methods: {
    validate: function (event) {
      if(this.validation) {
        const minLength = this.newPassword ? 6 : 1;
        const matching = this.confirmation ? this.value === this.mustMatch : true;
        if (this.value.length < minLength || !matching) {
          this.valid = false;
        }
        if(this.confirmation && matching) {
          this.valid = true;
        }

        // only do the server side check if the JS checks have passed
        if (this.valid !== false && !this.confirmation) {
          // Enforce password security
          this.checkPasswordRules().then(
            () => {
              this.passSecurityNeeds = this.valid;
              this.$emit("validated", this.valid);
            }
          );
        }
      } else {
        // this.passSecurityNeeds = true;
        this.$emit("validated", null);
      }
    },
    checkPasswordRules: function(pwd) {
      return http.post("/person/check_password", { password: this.value })
              .then((res) => {
                this.valid = res.data.valid;
              })
              .catch((error) => {
                this.valid = false;
              });
    },
    onPasswordFocus: function (event) {
      this.valid = null;
      this.$emit("validated", this.valid);
    },
    onPasswordUnfocus: function (event) {
      this.validate(event);
    },
  },
};
</script>
