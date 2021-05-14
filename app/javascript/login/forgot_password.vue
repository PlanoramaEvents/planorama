<template>
    <div class="forgot-password">
        <h3>Recover Password</h3>
        <p>Don't worry, this happens to the best of us.</p>
        <p>If an account with this address exists you will recieve an email with a link.</p>
        <b-alert :show="alert.visible" :variant="alert.variant">{{ alert.text }}</b-alert>
        <b-form v-if="!successfullySent" @submit="onSubmit">
            <login-email-field v-model="person.email" @validated="form.email.valid = $event"></login-email-field>
            <div class="d-flex flex-row-reverse">
                <b-button :disabled="submitDisabled" type="submit" variant="primary" class="px-5">Send me a link</b-button>
            </div>
        </b-form>
    </div>
</template>

<script>
import LoginEmailField  from './login_email_field';
import axios from '../axios';

export default {
    name:"ForgotPassword",
    data: () => ({
        person: {
            email: ''
        },
        alert: {
            variant: "success",
            visible: false,
            text: ''
        },
        successfullySent: false,
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
                axios.post('/people/password.json', { person: this.person }).then(data => {
                    this.successfullySent = data.status === 201
                    if(this.successfullySent)  {
                        this.alert.text = "TODO WRITE THIS COPY EMAIL SENT"
                        this.alert.variant = "success"
                        this.alert.visible = true
                    } else {
                        this.alert.text = "TODO WRITE THIS COPY EMAIL DIDN'T SEND"
                        this.alert.variant = "danger"
                        this.alert.visible = true
                    }
                }).catch(error => {
                    this.alert.text = "TODO WRITE THIS COPY EMAIL DIDN'T SEND"
                    this.alert.variant = "danger"
                    this.alert.visible = true
                });
            }
        }
    }
}
</script>
