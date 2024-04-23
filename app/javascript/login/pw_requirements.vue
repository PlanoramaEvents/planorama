<template>
  <div>
    <p>Aby chronić swoje konto, upewnij się, że Twoje hasło:</p>
    <ul>
      <li>Składa się z 6 lub więcej znaków</li>
      <li>Nie zawiera słowa "password"</li>
      <li>Nie zawiera Twojego adresu email</li>
      <li>Nie jest jednym z Twoich ostatnich haseł</li>
      <li>
        Hasło nie może być powszechnie używanym hasłem lub łatwo odgadnionym.
        Planorama korzysta z usługi
        <a href="https://haveibeenpwned.com/" target="_blank"
          >haveibeenpwned.com</a
        >,
        która jest udostępniana na licencji
        <a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" >CC BY 4.0</a>.
      </li>
    </ul>
    <p>
      Opcjonalnie, zalecamy stosowanie
      <a href="https://xkcd.com/936/" target="_blank"
        >Correct Horse Battery Staple"</a
      >paradigm.
    </p>
  </div>
</template>

<script>
export default {
  name: "PwRequirements",
};
</script>

<style></style>