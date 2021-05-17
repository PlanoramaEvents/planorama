<template>
<b-form-group
    id="input-email-group"
    label="Email address"
    label-for="input-email"
    :invalid-feedback="invalidFeedback"
    :state="valid"
>
    <b-form-input
        id="input-email"
        :value="value"
        @input="$emit('input', $event)"
        type="text"
        :state="valid"
        novalidate
        @focus="onEmailFocus"
        @blur="onEmailUnfocus"
    ></b-form-input>
</b-form-group>
</template>

<script>
import { LOGIN_NOT_AN_EMAIL, LOGIN_MISSING_EMAIL } from '../constants/errors';

export default {
    name: "LoginEmailField",
    props: {
        value: {
            type: String
        },
        validateNow: {
            type: Function
        }
    },
    data: () => ({
        valid: null
    }),
    computed: {
      invalidFeedback: function(){
            if (this.value.length > 0) {
                return LOGIN_NOT_AN_EMAIL
            }
            return LOGIN_MISSING_EMAIL
      },
    },
    watch: {
        validateNow: function(val) {
            this.validate()
            val(true)
        }
    },
    methods: {
        validate: function(event) {
            if(!this.value.match(/.+@.+\..+/)) {
                this.valid = false;
            }
            this.$emit('validated', this.valid)
        },
        onEmailUnfocus: function(event) {
            this.validate(event)
        },
        onEmailFocus: function(event) {
            this.valid = null;
            this.$emit('validated', this.valid)
        }
    }
}
</script>
