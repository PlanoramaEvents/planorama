<template>
<div class="login-screen">
    <div class="col-sm-8 offset-sm-2 col-lg-4 offset-lg-4">
        <plan-logo></plan-logo>
    </div>
    <div class="col-12 col-sm-8 offset-sm-2 col-lg-4 offset-lg-4">
        <router-view></router-view>
    </div>
    <plan-login-footer></plan-login-footer>
</div>
</template>

<script>
import PlanLogo from '../logo.vue';
import PlanLoginFooter from './login_footer.vue';

export default {
    name: "LoginScreen",
    components: {
        PlanLogo,
        PlanLoginFooter,
    },
}
</script>
