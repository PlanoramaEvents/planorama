<template>
    <img id="planorama-logo" :src="logoPath" alt="Planorama: Convention Planning" />
</template>

<script>
import LogoImage from './images/planorama_logo_transparent.png'

export default {
    name: "PlanLogo",
    data: () => ({
        logoPath: LogoImage
    })
}
</script>

<style lang="scss">
    #planorama-logo {
        width: 100%;
        margin-bottom: 2rem;
    }
</style>
