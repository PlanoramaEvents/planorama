<template>
    <div class="forgot-password">
        <h3>Reset Password</h3>
        <p>Don't worry, this happens to the best of us.</p>
        <p>If an account with this address exists, you will recieve an email with a link to complete the password reset process.</p>
        <b-alert :show="alert.visible" :variant="alert.variant">{{ alert.text }}</b-alert>
        <b-form @submit="onSubmit">
            <login-email-field v-model="person.email" @validated="form.email.valid = $event" :validateNow="form.email.validate"></login-email-field>
            <div class="d-flex flex-row-reverse">
                <b-button :disabled="submitDisabled" type="submit" variant="primary" class="px-5">Send me a link</b-button>
            </div>
        </b-form>
    </div>
</template>

<script>
import LoginEmailField  from './login_email_field';
import {http} from '../http';
import { validateFields } from '../utils';
import { LOGIN_INVALID_FIELDS } from '../constants/errors'

export default {
    name:"ForgotPassword",
    data: () => ({
        person: {
            email: ''
        },
        alert: {
            variant: "danger",
            visible: false,
            text: ''
        },
        successfullySent: false,
        form: {
            email: {
                valid: null,
                validate: null
            }
        }
    }),
    components: {
        LoginEmailField,
    },
    computed: {
        submitDisabled: function() {
            return this.form.email.valid === false
        }
    },
    methods: {
        onSubmit: async function(event) {
            event.preventDefault();
            await validateFields(this.form.email)
            if(this.form.email.valid === false) {
                this.error.text = LOGIN_INVALID_FIELDS;
                this.error.visible = true;
            } else {
                http.post('/people/password.json', { person: this.person }).then(data => {
                    this.successfullySent = data.status === 201
                    if (this.successfullySent) {
                        this.$router.push('/?alert=If+an+account+with+the+address+you+specified+exists+you+will+receive+an+email+with+a+password+reset+link.')
                    } else {
                        console.log(data)
                        this.alert.text = "TODO WRITE THIS COPY EMAIL DIDN'T SEND"
                        this.alert.visible = true
                    }
                }).catch(error => {
                    this.alert.text = "TODO WRITE THIS COPY EMAIL DIDN'T SEND"
                    this.alert.visible = true
                });
            }
        }
    }
}
</script>
