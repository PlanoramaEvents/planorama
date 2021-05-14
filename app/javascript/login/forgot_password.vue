<template>
    <div class="forgot-password">
        <h3>Recover Password</h3>
        <p>Don't worry, this happens to the best of us.</p>
        <p>If an account with this address exists you will recieve an email with a link.</p>
        <b-form @submit="onSubmit">
            <login-email-field v-model="person.email" @validated="form.email.valid = $event"></login-email-field>
            <div class="d-flex flex-row-reverse">
                <b-button :disabled="submitDisabled" type="submit" variant="primary" class="px-5">Send me a link</b-button>
            </div>
        </b-form>
    </div>
</template>

<script>
import { LOGIN_INVALID_FIELDS } from '../constants/errors';
import LoginEmailField  from './login_email_field';
import axios from '../axios';

export default {
    name:"ForgotPassword",
    data: () => ({
        person: {
            email: ''
        },
        error: {
            visible: false,
            text: ''
        },
        form: {
            email: {
                valid: null
            }
        }
    }),
    components: {
        LoginEmailField,
    },
    computed: {
        submitDisabled: function() {
            return this.form.email.valid === false || this.person.email.length < 1
        }
    },
    methods: {
        onSubmit: function(event) {
            event.preventDefault();
            if(this.form.email.valid === false) {
                this.error.text = LOGIN_INVALID_FIELDS;
                this.error.visible = true;
            } else {
                console.log("I will eventually be sending email here.");
                axios.post('/people/password.json', { person: this.person }).then(data => console.log(data))
            }
        }
    }
}
</script>
