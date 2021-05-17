<template>
    <footer>
        <terms-of-use-link></terms-of-use-link>
        <privacy-policy-link></privacy-policy-link>
    </footer>
</template>

<script>
import TermsOfUseLink from '../administration/terms_of_use_link';
import PrivacyPolicyLink from '../administration/privacy_policy_link'

export default {
    name: "PlanLoginFooter",
    components: {
        TermsOfUseLink,
        PrivacyPolicyLink,
    }
}
</script>

<style lang="scss" scoped>
    footer {
        margin-top: 2rem;
        display: flex;
        justify-content: space-evenly;
    }
</style>
