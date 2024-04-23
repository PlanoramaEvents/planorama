<template>
  <div>
    <!-- iea-modal.vue -->
    <b-modal id='iea-modal' size="lg" @show="onShow"
      hide-header-close no-close-on-backdrop no-close-on-esc
      @ok="okAction" @cancel="$emit('cancel', $event)"
      ok-title="Zgadzam się" cancel-variant="link">
      <template #modal-title>
        Umowa Pracownicza dotycząca Etyki i Polityki Prywatności Danych
        <!--Information Ethics Agreement for Staff-->
      </template>
      <div class="terms">
        <!--TODO use the database value -->
        <p>Ten system zawiera Dane Osobowe członków personelu, uczestników programu i potencjalnych uczestników programu. Obejmuje to imiona, adresy e-mailowe i numery telefonów, a także odpowiedzi na ankiety, proponowane i zaplanowane sesje programu, kopie korespondencji z uczestnikami programu i inne informacje.</p>
        <p>Dodatkowo, niektóre informacje są uważane za Dane Osobowe o Wrażliwym Charakterze zgodnie z Rozporządzeniem Parlamentu Europejskiego i Rady (UE) 2016/679 z dnia 27 kwietnia 2016 r. (RODO), w tym informacje demograficzne dotyczące niektórych uczestników programu i potencjalnych uczestników programu.</p>
        <p>Niniejsze warunki i postanowienia dokumentujące poniżej dotyczą wszystkich informacji przechowywanych w systemie.</p>
        <p>Aby uzyskać dostęp do tego systemu, musisz zgodzić się na poniższe oświadczenia:</p>
        <ul>
          <li>Rozumiem, że moje konto jest przeznaczone wyłącznie dla mojego osobistego użytku.</li>
          <li>BĘDĘ używać informacji przechowywanych w systemie WYŁĄCZNIE w celach planowania konwentu, w tym w celu opracowywania programu.</li>
          <li>BĘDĘ przestrzegać Zasad Ochrony Danych Programu oraz Polityki Prywatności konwentu.</li>
          <li>Akceptuję, że moje działania i korzystanie z tego systemu są rejestrowane i mogą być przeglądane przez administratora w razie potrzeby.</li>
          <li>Rozumiem, że jeśli moje konto zostanie zakończone, moje dane osobowe będą usuwane tak samo, jak dane uczestnika programu, jednak niektóre z moich Danych Osobowych (takie jak imię, adres e-mail, nazwa konta) mogą być przechowywane w niektórych dokumentach, takich jak notatki z sesji programu i pliki dziennika aplikacji.</li>
        </ul>

        <p>Poniżej przedstawiono niekompletną listę zakazów wynikającą z powyższych zasad, które również zgadzasz się przestrzegać:</p>
        <ul>
          <li>Nie będę udostępniał moich danych logowania nikomu innemu ani nie pozwolę nikomu innemu na korzystanie z sesji, do której już się zalogowałem.</li>
          <li>Jeśli ktoś inny potrzebuje dostępu do systemu, skieruję go do swojego kierownika działu, aby uzyskał własne konto.</li>
          <li>Jeśli kiedykolwiek odkryję, że moje dane logowania zostały przechwycone lub naruszone w jakikolwiek sposób, niezwłocznie powiadomię kierownika Programu, przewodniczącego lub innych pracowników posiadających uprawnienia administratora w tym systemie za pomocą dostępnych lub koniecznych środków, aby moje konto mogło zostać zablokowane przed użyciem przez inne osoby.</li>
          <li>Jeśli moje hasło zostało naruszone, natychmiast je zaktualizuję.</li>
          <li>Jeśli mam dostęp do Wrażliwych Danych Osobowych konwentowych, podzielę się tymi informacjami tylko z innymi członkami personelu, którzy również mają taki dostęp.</li>
          <li>Nie będę przeglądał ani korzystał z informacji uczestnika, chyba że istnieje uzasadniona potrzeba konwentu.</li>
          <li>Nie będę przeglądał danych dla celów rozrywkowych/rozrywki ani nie będę używał ich do aktualizacji mojej prywatnej książki adresowej lub listy kontaktów.</li>
          <li>Nie będę udostępniał informacji znalezionych w tym systemie osobom spoza personelu ani tym, którzy nie mają uzasadnionej potrzeby służbowej do ich poznania.</li>
          <li>Nie będę celowo fałszować danych przechowywanych w tym systemie ani wprowadzać nieprawidłowych danych do systemu.</li>
        </ul>

        <p>Klikając poniżej przycisk „Zgadzam się”, niniejszym akceptuję przestrzeganie powyższych ograniczeń dotyczących korzystania. Uznam, że niewłaściwe korzystanie z tego systemu może wiązać się z konsekwencjami osobistymi, biznesowymi i prawny
mi. Powyższa lista nie wyczerpuje wszystkich zakazanych czynności. Będę używać mojego najlepszego osądu, decydując, które czynności są odpowiednie.</p>

        <!-- gail's shorter version -->
        <!--
        <p>Ten system zawiera dane osobowe ludzi, w tym pewne informacje uważane za wrażliwe. Aby zachować te dane bezpiecznie, zgadzam się na poniższe warunki:</p>
        <ul>
          <li>Nie będę udostępniał mojego konta nikomu, a jeśli zostanie ono naruszone, natychmiast podejmę kroki w celu zminimalizowania zagrożenia, w tym poinformowanie Dywizji Programowej Chicon 8.</li>
          <li>Będę przeglądał i korzystał z informacji w tym systemie wyłącznie w celach planowania konwentu.</li>
          <li>NIE będę przeglądał tych danych w celach rozrywkowych ani nie będę ich używał do aktualizacji mojej prywatnej książki adresowej.</li>
          <li>Rozumiem, że moje korzystanie z tego oprogramowania będzie monitorowane, i nawet jeśli odejdę, niektóre moje dane osobowe pozostaną w systemie w celach audytowych.</li>
          <li>Będę przestrzegał wytycznych określonych w Polityce Ochrony Danych Dywizji Programowej oraz Polityce Prywatności Chicon.</li>
        </ul>
        <p>Rozumiem, że niewłaściwe korzystanie z tego systemu może wiązać się z konsekwencjami osobistymi, biznesowymi i prawnymi. Powyższa lista nie wyczerpuje wszystkich zakazanych czynności. Będę używał swojego najlepszego osądu, decydując, które działania są odpowiednie.</p>
        -->
      </div>
    </b-modal>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
// import { FETCH_IEA, SIGN_IEA, GET_IEA_UNSIGNED } from '../administration/agreement.store'
import toastMixin from '../shared/toast-mixin'
export default {
  name: "IeaModal",
  computed: {
    ...mapState('admin/agreements', ['information_ethics', 'ieaUnsigned']),
  },
  mixins: [toastMixin],
  data: () => ({
    showModal: false
  }),
  methods: {
    // ...mapActions('admin/agreements', {
    //   fetchIea: FETCH_IEA,
    //   signIea: SIGN_IEA,
    //   getIeaUnsigned: GET_IEA_UNSIGNED,
    // }),
    okAction(event) {
      this.$emit('ok', event)
      // Got to the "home page"
      this.$router.push('/');
      // not signing for now
      /*
      this.signIea(this.toastSuccessFailure('Information Ethics Agreement Signed')).then(() => {
        this.$emit('ok', event)
      })*/
    },
    onShow() {
      // not fetching for now because hard coded
      //this.fetchIea();
      //this.showModal = true;
      //this.getIeaUnsigned().then(() => {
      // if(this.ieaUnsigned) {
      //  }
      //})
    }
  },
}
</script>

<style lang="scss" scoped>
.terms {
  max-height: 50vh;
  overflow-y: auto;
}
</style>
