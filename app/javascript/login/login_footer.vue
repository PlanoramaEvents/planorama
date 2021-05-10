<template>
    <footer>
        <div class="col-12 col-sm-8 offset-sm-2 col-lg-4 offset-lg-4">
            <terms-of-use-link></terms-of-use-link>
            <privacy-policy-link></privacy-policy-link>
        </div>
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
        div {
            display: flex;
            justify-content: space-evenly;
        }
    }
</style>
