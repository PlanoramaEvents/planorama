import PlanLogin from './login.vue';
import { action } from '@storybook/addon-actions';

import { LOGIN_MISSING_PASSWORD, LOGIN_INVALID_FIELDS } from '../constants/strings';

export default {
    title: 'Login',
    component: PlanLogin,
    argTypes: {
        onClick: { action: 'click' }
    }
};

const Template = (args) => {
    return {
        components: { PlanLogin },
        mounted: function () {
            let component = this.$children[0]
            component.person.email = args.email || component.person.email,
                component.person.password = args.password || component.person.password,
                component.error = { ...component.error, ...args.error };
            component.form = { ...component.form, ...args.form };
            component.onSubmit = (event) => {
                event.preventDefault();
                action('onSubmit')('Submitted!')
            }
        },
        template: '<PlanLogin/>'
    }
}

export const Default = Template.bind({});
Default.args = {
};

export const EmptyEmail = Template.bind({});
EmptyEmail.args = {
    form: {
        email: {
            valid: false
        }
    }
}

export const EmptyPassword = Template.bind({});
EmptyPassword.args = {
    form: {
        password: {
            valid: false,
            invalidMessage: LOGIN_MISSING_PASSWORD
        }
    }
}

export const IncorrectEmail = Template.bind({});
IncorrectEmail.args = {
    email: 'test',
    form: {
        email: {
            valid: false
        }
    }
}

export const InvalidFields = Template.bind({});
InvalidFields.args = {
    error: {
        text: LOGIN_INVALID_FIELDS,
        visible: true
    },
    form: {
        email: {
            valid: false
        },
        password: {
            valid: false,
            invalidMessage: LOGIN_MISSING_PASSWORD
        }
    }
}
