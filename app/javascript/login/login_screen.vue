<template>
<div class="login-screen container">
    <plan-logo></plan-logo>
    <router-view></router-view>
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

<style lang="scss" scoped>
@media (max-width: 576px) {
    .login-screen {
        width: 100%;
    }
}
@media (min-width: 577px) {
    .login-screen {
        width: 500px;
        margin: 0 auto;
    }
}
</style>
