<template>
  <div>
    <p>In order to protect your account, make sure your password:</p>
    <ul>
      <li>Is 6 or more characters</li>
      <li>Does not contain the word "password"</li>
      <li>Does not contain your email address</li>
      <li>
        Password must not be a commonly used password of easily guessable.
        Planorama makes use of the service
        <a href="https://haveibeenpwned.com/" target="_blank"
          >haveibeenpwned.com</a
        >
        which is provided under the <a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" >CC BY 4.0</a> license.
      </li>
    </ul>
    <p>
      Optionally, we recommend you follow the
      <a href="https://xkcd.com/936/" target="_blank"
        >Correct Horse Battery Staple</a
      >
      paradigm.
    </p>
  </div>
</template>

<script>
export default {
  name: "PwRequirements",
};
</script>

<style></style>
