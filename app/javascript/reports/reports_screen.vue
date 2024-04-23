<template>
  <div class="mb-3 scrollable">
    <p class="mt-2">To są raporty tymczasowe.</p>
    <ul>
      <li><router-link to="#participants">Uczestnicy</router-link></li>
      <li><router-link to="#sessions">Sesje</router-link></li>
      <li><router-link to="#conflicts">Konflikty</router-link></li>
      <li><router-link to="#schedule">Harmonogram</router-link></li>
      <li><router-link to="#prog-ops">Operacje programowe</router-link></li>
    </ul>
    <h5><a id="participants"></a>Uczestnicy</h5>
    <ul>
      <li>
        <a href="/report/participant_selections" target="_blank">Wybory uczestników</a><br />
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Sesje i rankingi wybrane przez osoby, jedna linia na osobę i sesję<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, tytuł sesji, ranking, uwagi dotyczące rankingu, obszary sesji, czy osoba została przypisana (t/n), czy sesja została zaplanowana (t/n)<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: dowolna sesja wybrana przez co najmniej jedną osobę<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: status uczestnika: applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <a href="/report/participant_availabilities" target="_blank">Dostępności uczestników</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Informacje z zakładki "Dostępność i zainteresowania" osoby (dzienny limit i limit na konferencję, dni/godziny dostępności, specjalne wydarzenia do udziału)<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), dostępności (dni/godziny), limity (dzienny & na konferencję/"globalny"), wyłączenia (specjalne wydarzenia do udziału), uwagi dotyczące dostępności<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: status uczestnika: applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <a href="/report/assigned_sessions_by_participant" target="_blank">Przypisane sesje według uczestnika</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do sesji, jedna linia na osobę i sesję<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, tytuł sesji, rola osoby w sesji, czy sesja została zaplanowana (t/n)<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: dowolna sesja z co najmniej jedną osobą przypisaną jako moderator, uczestnik, niewidoczny uczestnik lub zarezerwowany<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: rola sesji: moderator, uczestnik, niewidoczny uczestnik, zarezerwowany
        </p>
      </li>
      ```html
      <li>
        <a href="/report/people_and_submissions" target="_blank">Osoby i zgłoszenia do ankiety</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Lista przeprowadzonych ankiet, wraz z datą i godziną przesłania, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, główny adres e-mail, typ uczestnictwa, status uczestnika, przeprowadzone ankiety<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: status uczestnika: applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <span v-if="currentUserIsStaff" class="text-muted font-italic" title="Nie masz odpowiednich uprawnień, aby wygenerować ten raport." v-b-tooltip>Uczestnicy i osoby do których nie należy ich przypisywać</span>
        <a href="/report/participant_do_not_assign_with" target="_blank" v-if="currentUserIsAdmin">Uczestnicy i osoby do których nie należy ich przypisywać</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby, które nie powinny być przypisywane do tych samych sesji, jedna linia na osobę i sesję; dostępne tylko dla użytkowników z uprawnieniami do przeglądania wrażliwych danych<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, tytuł sesji, obszary sesji, nazwy innych osób przypisanych do sesji, nazwy osób, których nie należy przypisywać do tej samej sesji<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy, którzy podali informacje o tym, z kim nie należy ich przypisywać
        </p>
      </li>
      <li>
        <a href="/report/session_reports/participants_over_session_limits" target="_blank">Uczestnicy przekraczający dzienny limit</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby zaplanowane na więcej sesji, niż określono w ich dziennym i/lub całkowitym limicie, jedna linia na osobę i przekroczony limit dzienny/całkowity<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, dzień (w tym poszczególne dni i &quot;Wszystkie&quot; dla limitu całkowitego), liczba sesji (liczba przypisanych sesji), limit osoby (określony w zakładce &quot;Dostępność i zainteresowania&quot;)<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy przekraczający określony dzienny lub całkowity limit
        </p>
      </li>
      <li>
        <a href="/report/session_reports/participants_over_con_session_limits" target="_blank">Uczestnicy przekraczający limit konferencji</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby zaplanowane na więcej sesji, niż pozwala konferencja, z pewnymi wyjątkami dotyczącymi formatu sesji, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, liczba sesji (liczba przypisanych sesji), limit konferencji (maksymalna liczba sesji dozwolona przez konferencję, czyli 6)<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje oprócz tych w formatach: autografy, spotkania, czytania, próby, rozmowy przy stole<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy przekraczający limit konferencji 6 sesji, bez uwzględnienia wyjątków formatu
        </p>
      </li>
      <li>
        <a href="/report/session_reports/non_accepted_on_schedule" target="_blank">Niezaakceptowani uczestnicy na zaplanowanych sesjach</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby o statusie uczestnika inny niż &quot;zaakceptowany&quot; lub &quot;not_set&quot; przypisane do zaplanowanych sesji, jedna linia na osobę i sesję<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, tytuł sesji, obszary sesji<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy o statusie uczestnika inny niż &quot;zaakceptowany&quot; lub &quot;not_set&quot;
        </p>
      </li>
      <li>
        <a href="/report/session_reports/invited_accepted_not_scheduled" target="_blank">Zaproszeni i zaakceptowani, którzy nie są na liście sesji</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby o statusie uczestnika zaakceptowany, zaproszony lub oczekujący na zaproszenie, które nie są przypisane do żadnych sesji, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), biogram osoby<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: osoby o statusie uczestnika zaakceptowany, zaproszony lub oczekujący na zaproszenie, które nie są przypisane do żadnej sesji, lub które są przypisane jako niewidoczni uczestnicy lub zarezerwowani na jednej lub więcej sesji
        </p>
      </li>
      <li>
        <a href="/report/people_reports/record_stream_permissions" target="_blank">Uprawnienia sesji uczestnika (nagrywanie, przesyłanie strumieniowe i ograniczenia demograficzne)</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Lista uczestników wraz z ich uprawnieniami do nagrywania i przesyłania strumieniowego oraz wyłączeniami, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, główny adres e-mail, typ uczestnictwa, status uczestnika, uprawnienia do przesyłania strumieniowego, wyłączenia przesyłania strumieniowego, uprawnienia do nagrywania, wyłączenia nagrywania, tematy do unikania, harmonogram<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/people_reports/moderators" target="_blank">Uczestnicy, którzy moderują co najmniej jedną sesję</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby pełniące rolę moderatora co najmniej w jednej sesji, wraz z informacjami o sesji, jedna linia na osobę i sesję<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, główny adres e-mail, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), status uczestnika, tytuł sesji, środowisko sesji<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy
        </p>
      </li>
      <li>
        <a href="/report/people_reports/social_media" target="_blank">Uczestnicy posiadający media społecznościowe</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Informacje o mediach społecznościowych uczestników, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Opublikowana nazwa, typ uczestnictwa, status uczestnika, biogram uczestnika, blok mediów społecznościowych uczestnika<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy i uczestnicy przypisani do co najmniej jednej zaplanowanej sesji
        </p>
      </li>
      <li>
        <a href="/report/people_reports/mis_matched_envs" target="_blank">Uczestnicy z niezgodnymi środowiskami sesji i typami uczestnictwa</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Uczestnicy, których typ uczestnictwa nie odpowiada środowisku sesji, do których są przypisani, jedna linia na uczestnika i sesję<br />
          <strong><em>Pola</em></strong>: Opublikowana nazwa, główny adres e-mail, typ uczestnictwa, status uczestnika, tytuł sesji, sala sesji, czas rozpoczęcia sesji, środowisko sesji<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy i uczestnicy o typie uczestnictwa &quot;wirtualne&quot; przypisani do sesji o środowisku &quot;hybrydowe&quot; lub &quot;stacjonarne&quot;, lub uczestnicy o typie uczestnictwa &quot;stacjonarne&quot; przypisani do sesji o środowisku &quot;wirtualne&quot;
       </p>
      </li>
      <li>
        <a href="/report/session_reports/streamed_and_recorded" target="_blank">Zaplanowane sesje transmitowane i/lub nagrywane na żywo</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Informacje o transmisji na żywo i nagrywaniu, jedna linia na sesję<br />
<strong><em>Pola</em></strong>: Tytuł sesji, czas rozpoczęcia sesji, sala sesji, format sesji, środowisko sesji, czy sesja jest transmitowana na żywo (t/n), czy sesja jest nagrywana (t/n)<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje
        </p>
      </li>
    </ul>

    <h5><a id="conflicts"></a>Konflikty</h5>
    <ul>
      <li>
        <a href="/report/conflict_reports/people_outside_availability" target="_blank">Osoby spoza dostępności</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby zaplanowane na dni/godziny, których nie oznaczyły jako dostępne, jedna linia na osobę i sesję, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, dostępność uczestnika (dni/godziny)<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/people_double_booked" target="_blank">Podwójne rezerwacje osób</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do więcej niż jednej zaplanowanej sesji w tym samym czasie, jedna linia na osobę i wystąpienie podwójnej rezerwacji, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, czas, tytuł sesji, obszar(y) sesji, sala, tytuł sesji konfliktu, obszar sesji konfliktu, sala konfliktu<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/person_exclusion_conflicts" target="_blank">Osoba zaplanowana w konflikcie z wydarzeniem</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do sesji, która odbywa się o tej samej porze co specjalne wydarzenie, na które chcą uczęszczać, jedna linia na wystąpienie konfliktu, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sesja konfliktu (specjalne wydarzenie), czas rozpoczęcia sesji konfliktu (specjalne wydarzenie)<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/back_to_back" target="_blank">Z powrotem do tyłu</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do dwóch sesji z rzędu (gdzie druga sesja zaczyna się mniej niż 40 minut po zakończeniu pierwszej), jedna linia na parę sesji, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji 1, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, tytuł sesji 2, obszar(y) sesji 2, czas rozpoczęcia sesji 2, czas trwania sesji 2, sala 2<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/back_to_back_to_back" target="_blank">Z powrotem do tyłu do tyłu</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do trzech sesji z rzędu (gdzie jedna sesja zaczyna się mniej niż 40 minut po poprzedniej), jedna linia na zestaw 3 sesji<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji 1, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania ses ji, sala, tytuł sesji 2, obszar(y) sesji 2, czas rozpoczęcia sesji 2, czas trwania sesji 2, sala 2, tytuł sesji 3, obszar(y) sesji 3, czas rozpoczęcia sesji 3, czas trwania sesji 3, sala 3<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="report/conflict_reports/multiple_sessions_in_room" target="_blank">Wiele sesji w jednej sali</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Dwie lub więcej sesji zaplanowane w tej samej sali o tej samej dacie/godzinie, jedna linia na wystąpienie, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Sala, tytuł sesji, tytuł sesji konfliktu, czas rozpoczęcia<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/all_ignored_conflicts" target="_blank">Zignorowane konflikty osób</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Zignorowane konflikty w tych kategoriach: osoby spoza dostępności, podwójne rezerwacje osób, osoba zaplanowana w konflikcie z wydarzeniem, z powrotem do tyłu, jedna linia na zignorowany konflikt<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, imię osoby, typ konfliktu<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/all_conflicts" target="_blank">Wszystkie konflikty</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Wszystkie konflikty w tych kategoriach: osoby spoza dostępności, podwójne rezerwacje osób, osoba zaplanowana w konflikcie z wydarzeniem, z powrotem do tyłu, jedna linia na konflikt<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, imię osoby, typ konfliktu<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
    </ul>

    <h5><a id="schedule"></a>Harmonogram</h5>
    <ul>
      <li>
        <a href="/report/schedule_by_room_then_time" target="_blank">Harmonogram według sal, a następnie czasu</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Wszystkie zaplanowane sesje, jedna linia na salę i dzień/godzinę<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, przypisani uczestnicy, moderatorzy<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/schedule_by_person" target="_blank">Harmonogram według uczestników</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Harmonogram dla każdego uczestnika, jedna linia na osobę i sesję<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, sala, moderator (t/n), niewidoczny uczestnik (t/n)<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/schedule_accpetance" target="_blank">Uczestnicy z zatwierdzonymi wersjami roboczymi i ustalonymi harmonogramami</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby z statusem uczestnika, który nie jest odrzucony, odrzucony, ani nie_ustawiony, z informacją, czy i kiedy zatwierdzili swoje wersje robocze i ustalone harmonogramy, z uwagami, jeśli nie zatwierdzili, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, podstawowy adres e-mail, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), status uczestnika, zatwierdzenie wersji roboczej, uwagi do wersji roboczej, czas edycji wersji roboczej, zatwierdzenie ustalonego harmonogramu, uwagi do ustalonego harmonogramu, czas edycji ustalonego harmonogramu<br />
          <strong><em>Dane osobowe zawarte</em></strong>: osoby z statusem uczesnika, który nie jest odrzucony, odrzucony, ani nie_ustawiony, w tym osoby nieprzypisane do żadnych sesji
        </p>
      </li>
    </ul>
    
  <h5><a id="prog-ops"></a>Operacje Programowe</h5>
  <ul>
    <li>
      <a href="/report/session_reports/daily_grid" target="_blank">Dzienna siatka</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Informacje o sesji dla dziennego harmonogramu, jedna linia na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, format sesji, czas rozpoczęcia sesji, czas trwania sesji, sala sesji<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w ostatniej publikacji
      </p>
    </li>
    <li>
      <a href="/report/program_ops_reports/back_of_badge" target="_blank">Z tyłu identyfikatora</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Harmonogram uczestnika do łączenia korespondencji pocztowej, jedna linia na osobę, z zmienną długością w zależności od liczby przypisanych sesji<br />
        <strong><em>Pola</em></strong>: Opublikowane imię, Tytuł sesji 1, Skrócony tytuł sesji 1 (maksymalnie 30 znaków), Czas rozpoczęcia sesji 1, Czas trwania sesji 1, Sala sesji 1, Format sesji 1, Rola uczestnika sesji 1, następnie powtarzaj 7 kolumn sesji, jeśli to konieczne<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje ze statusem "reviewed" lub "revised"<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy ze statusem uczestnictwa "osobiście" lub "hybrydowo"
      </p>
    </li>
    <li>
      <a href="/report/program_ops_reports/sign_up_sessions" target="_blank">Sesje wymagające rejestracji uczestników</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Maksymalna liczba uczestników w sesjach wymagających rejestracji, jedna linia na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, opis sesji, sala sesji, czas rozpoczęcia sesji, czas trwania sesji, format sesji, uczestnicy, środowisko sesji, maksymalna liczba uczestników<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w ostatniej publikacji<br />
      </p>
    </li>
    <li>
      <a href="/report/session_reports/session_needs" target="_blank">Potrzeby sesji</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Wymagania dotyczące przygotowania sesji, jedna linia na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, czas rozpoczęcia sesji, sala sesji, środowisko sesji, format sesji, obszar(y) sesji, wymagane cechy&#8725;usługi sali, uwagi dotyczące techniki&#8725;hotelu, ustawienie sali<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w ostatniej publikacji<br />
      </p>
    </li>
    <li>
      <a href="/report/program_ops_reports/session_minors" target="_blank">Sesje i niepełnoletni</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Uczestnictwo niepełnoletnich i ograniczenia wiekowe uczestników, jedna linia na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, opis sesji, czas rozpoczęcia sesji, sala sesji, ograniczenie wiekowe uczestników, uczestnictwo niepełnoletnich<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
      </p>
    </li>
    <li>
      <a href="/report/program_ops_reports/room_signs" target="_blank">Dane na tabliczki drzwiowe do łączenia korespondencji pocztowej</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Dane na tabliczki drzwiowe do łączenia korespondencji pocztowej, jedna linia na salę i dzień tygodnia<br />
        <strong><em>Pola</em></strong>: Sala, dzień tygodnia, sesje (tytuł, czas rozpoczęcia, opis, moderatorzy, uczestnicy)<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w ostatniej publikacji<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
      </p>
    </li>
    <li>
      <a href="/report/program_ops_reports/table_tents" target="_blank">Dane na stoliki do łączenia korespondencji pocztowej</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Dane na stoliki do łączenia korespondencji pocztowej, jedna linia na sesję i uczestnika<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, opublikowane imię, opis sesji, zaplanowane uwagi uczestnika, moderatorzy i ich zaimek, uczestnicy i ich zaimek<br />
        <strong><em>Dane sesji zawarte</em></strong>: opublikowane sesje w ostatniej publikacji, ze środowiskiem "osobiście" lub "hybrydowo"<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
      </p>
    </li>
    <li>
      <a href="/report/program_ops_reports/virtual_people" target="_blank">Adresy e-mail uczestników i sesje wirtualne</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Lista adresów e-mail moderatorów i uczestników opublikowanych sesji, z informacją, czy są przypisani do jakichkolwiek sesji o środowisku wirtualnym, jedna linia na uczestnika<br />
        <strong><em>Pola</em></strong>: Opublikowane imię, imię, czy osoba jest przypisana do sesji wirtualnej (tak &#8725; nie), główny adres e-mail, inne adresy e-mail<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w ostatniej publikacji<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy i uczestnicy
      </p>
    </li>
    <li>
      <a href="/report/integrations_reports/airmeet_magic_link" target="_blank">Magiczne linki do Airmeet</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Linki pozwalające na dostęp do Airmeet dla każdego uczestnika (prelegenta), jedna linia na osobę. Do stosowania w nagłych przypadkach obsługi klienta.<br />
        <strong><em>Pola</em></strong>: Opublikowane imię, główny adres e-mail, magiczny link do Airmeet<br />
        <strong><em>Dane osobowe zawarte</em></strong>: wszyscy moderatorzy i uczestnicy przypisani do sesji wirtualnych
      </p>
    </li>
    <li>
      <a href="/report/integrations_reports/airmeet_diffs" target="_blank">Zmiany w Airmeet</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Zmiany w informacjach osobowych od ostatniej synchronizacji (ręcznej lub automatycznej) z Airmeet, jedna linia na zmianę<br />
        <strong><em>Pola</em></strong>: Czas ostatniej synchronizacji, czas ostatniej aktualizacji osoby, adres e-mail w Airmeet, co się zmieniło, z czego, na co<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje o środowisku "wirtualnym" w ostatniej publikacji<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy i uczestnicy przypisani do opublikowanych sesji wirtualnych, których opublikowane imię, adres e-mail lub biogram zmieniły się od ich ostatniej synchronizacji z Airmeet
      </p>
    </li>
  </ul>
  <div style="clear: both; height: 5rem;">&nbsp;</div>
  <span v-if="currentUserIsStaff" class="text-muted font-italic" title="Nie masz odpowiedniego zestawu uprawnień do uruchomienia tego raportu." v-b-tooltip>Uprawnienia użytkownika</span>
  <a href="/report/program_ops_reports/user_privileges" target="_blank" v-if="currentUserIsAdmin">Uprawnienia użytkownika</a>
  <p class="ml-2">
    <strong><em>Opis</em></strong>: Lista logowania (główny adres e-mail), jedna linia na osobę<br />
    <strong><em>Pola</em></strong>: Główny adres e-mail, opublikowane imię, lista ról, ostatnio zalogowany(a) o<br />
    <strong><em>Dane osobowe zawarte</em></strong>: wszyscy ludzie z rolą lub personelem oraz&#8725;lub administracją
  </p>
  </div>
</template>

<script>
import personSessionMixin from '@/auth/person_session.mixin'

export default {
  name: "ReportsScreen",
  mixins: [
    personSessionMixin
  ]
}
</script>

<style>

</style>
