<template>
  <div class="row scrollable">
    <div class="col-12">
      <p>Witaj w Planoramie, {{currentUser.published_name}}!</p>
      <p>
        Będziesz korzystać z tej strony między teraz a konwencją, aby przeglądać i zarządzać swoim profilem, zainteresowaniami oraz harmonogramem.
      </p>
      <div v-if="!draftSchedule && doneLoading">
        <page-content-display name="dashboard-default">
          <p>
            Aby rozpocząć, kliknij <a href="/#/profile">Profil</a>.
          </p>
          <p>
            Obecnie w profilu znajduje się 5 zakładek. Musisz odwiedzić każdą z nich.
          </p>
          <ul>
            <li>
              <b>Zakładka Ogólna</b>
              <ul>
                <li>
                  Zaktualizuj swoje imię, nazwisko, zaimki, adres e-mail, biografię oraz media społecznościowe, jeśli jest to konieczne.
                </li>
                <li v-if="eventVirtual">
                  Jeśli nie będziesz uczestniczyć w konwentu osobiście, daj nam znać strefę czasową, w której będziesz, gdy będziesz uczestniczyć online.
                </li>
              </ul>
            </li>
            <li>
              <b>Demografia i Społeczność</b>
              <ul>
                <li>Wypełnij swoje informacje, jeśli jest to konieczne.</li>
              </ul>
            </li>
            <li>
              <b>Dostępność</b>
              <ul>
                <li>
                  Wypełnij maksymalną liczbę elementów programu, w których chcesz uczestniczyć.
                </li>
                <li>
                  Wybierz bloki czasowe, w których będziesz dostępny podczas konwentu w kalendarzu dostępności.
                </li>
                <li>
                  Wybierz wszystkie istotne elementy, wobec których nie chcesz być zaplanowany.
                </li>
                <li>
                  Daj nam znać, jakie inne ograniczenia czasowe masz, korzystając z pola tekstowego.
                </li>
              </ul>
            </li>
            <li>
              <b>Wybór Sesji</b>
              <ul>
                <li>
                  Użyj tej zakładki, aby powiedzieć nam, które elementy programu Cię interesują.
                </li>
                <li>
                  Możesz filtrować opcje dla jednej dziedziny, przeglądać wszystkie opcje (ponad 600!) lub wyszukiwać na podstawie tekstu w tytule i opisie. (Uwaga: Musisz kliknąć przycisk wyszukiwania - naciśnięcie Enter nie działa.)
                </li>
                <li>
                  Wybierz sesje, korzystając ze wskaźnika po prawej stronie opisu. Twoje wybory zostaną automatycznie zapisane.
                </li>
                <li v-if="eventVirtual">
                  Chociaż niektóre elementy są oznaczone lub opisane jako online, nie jesteśmy pewni, czy odbędą się osobiście czy online, dlatego każdy może zapisywać się na elementy, które nie są oznaczone żadnym z tych sposobów.
                </li>
              </ul>
            </li>
            <li>
              <b>Ranking Sesji</b>
              <p>
                Lista wybranych przez Ciebie sesji zostanie tutaj wyświetlona. Dla każdej sesji:
                <ul>
                  <li>
                    Dodaj ranking od 1 do 3. System rankingowy jest wyjaśniony na zakładce. Możesz nie oceniać paneli.
                  </li>
                  <li>
                    Określ preferencje moderacji dla poszczególnych elementów.
                  </li>
                  <li>
                    Korzystaj z pola tekstowego, aby powiedzieć nam, dlaczego jesteś dobrym wyborem do tego panelu i co wniesiesz.
                  </li>
                </ul>
              </p>
              <p>
                Prosimy postępuj zgodnie z dodatkowymi wskazówkami, jeśli są dostępne.
                <ul>
                  <li>
                    Często wystarczy jedno lub dwa zdania; nie wymagamy esejów.
                  </li>
                  <li>
                    Mamy około 1000 potencjalnych panelistów i około dwóch dziesiątek pracowników zaangażowanych w przydział panelistów; ten krok pozwala nam dowiedzieć się więcej o Tobie w kontekście konkretnej sesji.
                  </li>
                </ul>
              </p>
            </li>
          </ul>
        </page-content-display>
      </div>
      <div v-if="displayDraftSchedule">
        <page-content-display name="dashboard-schdule"></page-content-display>
        <person-schedule-display :sessions="sessions" title="Twój Wstępny Harmonogram">
          <template #message>
            <router-link to="/profile/draft-schedule">Zatwierdź swój wstępny harmonogram<br />lub zgłoś zmiany.</router-link>
          </template>
        </person-schedule-display>
      </div>
      <div v-if="firmSchedule">
        <page-content-display name="dashboard-schedule"></page-content-display>
        <person-schedule-display :sessions="sessions" title="Twój Harmonogram">
          <template #message>
            <router-link to="/profile/schedule">Zatwierdź swój harmonogram<br />lub zgłoś zmiany.</router-link>
          </template>
        </person-schedule-display>
      </div>
    </div>
  </div>
</template>

<script>
import { personSessionMixin, toastMixin} from '@/mixins';
import { mapActions } from 'vuex'; 
import { FETCH_WORKFLOWS, scheduleWorkflowMixin } from '@/store/schedule_workflow';
import PersonScheduleDisplay from '@/profile/person_schedule_display.vue';
import { eventVirtualMixin } from '@/shared/event-virtual.mixin';
import PageContentDisplay from '@/page-content/page_content_display.vue'

export default {
  name: "Dashboard",
  mixins: [personSessionMixin, toastMixin, scheduleWorkflowMixin, eventVirtualMixin],
  components: {
    PersonScheduleDisplay,
    PageContentDisplay
  },
  methods: {
    ...mapActions({
      fetchScheduleWorkflows: FETCH_WORKFLOWS,
      get: 'jv/get'
    }),
  },
  data: () => ({
    doneLoading: false,
    sessions: {},
  }),
  mounted() {
    // stopgap for not loading the session workflows earlier when logged in 
    this.fetchScheduleWorkflows().then(_ => {
      this.doneLoading = true
      if(this.draftSchedule) {
        let endpoint = this.displayDraftSchedule ? 'snapshot_schedule' : 'live_sessions'
        this.get(`/person/${this.currentUser.id}/${endpoint}`).then(data => {
          const {_jv, ...filtered_data} = data;
          this.sessions = filtered_data;
        });
      }
    });
  }
}
</script>

<style>

</style>
