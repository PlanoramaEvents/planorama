import Vue from 'vue/dist/vue.esm';

import { BootstrapVue } from 'bootstrap-vue';

import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';

import TermsOfUse from '../administration/terms_of_use.vue'

Vue.use(BootstrapVue)

const app = new Vue({
    components: {
        TermsOfUse,
    },
})
document.addEventListener('DOMContentLoaded', () => {
    app.$mount('#terms-app');
})
