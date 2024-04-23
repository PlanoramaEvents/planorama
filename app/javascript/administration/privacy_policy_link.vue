<template>
    <a :href="privacyPolicyLink" target="_blank">Polityka prywatności</a>
</template>

<script>
import settingsMixin from '@/store/settings.mixin'

export default {
    name: "PrivacyPolicyLink",
    mixins: [
        settingsMixin
    ],
    computed: {
        privacyPolicyLink() {
            return this.configByName('privacy_policy_link') || "https://chicagoworldcon.github.io/planorama/privacy" 
        }
    }
}
</script>
