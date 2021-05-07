<template>
    <div class="col-12 col-md-8 offset-md-2 col-lg-4 offset-lg-4">
        <b-form @submit="onSubmit" @reset="onReset">
            <b-form-group
                id="input-group-1"
                label="Email address"
                label-for="input-1"
            >
                <b-form-input
                    id="input-1"
                    v-model="form.email"
                    type="email"
                    required
                ></b-form-input>
            </b-form-group>
            <b-form-group
                id="input-group-2"
                label="Password"
                label-for="input-2"
                description="Passwords must contain: 6 or more characters. Password cannot contain: the word 'password' or your username"
            >
                <b-form-input
                    id="input-2"
                    v-model="form.password"
                    type="password"
                    required
                ></b-form-input>
            </b-form-group>
            <b-button type="submit" variant="primary">Submit</b-button>
            <b-button type="reset">Reset</b-button>
        </b-form>
    </div>
</template>

<script>
export default {
    name: "PlanLogin",
    data() {
        return {
            form: {
                email: '',
                password: '',
            }
        }
    },
    methods: {
        onSubmit: function(event) {
            event.preventDefault();
            console.log("hey look i submitted: your email is ", this.form.email);
        },
        onReset: function() {
            event.preventDefault();
            this.form.email = '';
            this.form.password = '';
            this.show = false;
            this.$nextTick(() => this.show = true);
        }
    }
}
</script>
