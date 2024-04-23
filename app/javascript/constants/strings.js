const twoLines = (line1, line2) => (h) =>  h('p', {}, [line1, h('br'), line2]);
const errorMessage = (message) => (errorCode) => twoLines(message, `Kod błędu: ${errorCode}`);
const titleCase = (model) => `${model.substring(0, 1).toUpperCase()}${model.substring(1)}`;
const nLines = (lines) => (h) => h('p', {}, lines.reduce((p, c) => [...p, c, h('br')], []));

module.exports = {
    // login page
    LOGIN_401: "Nazwa użytkownika lub hasło, które wprowadziłeś, jest nieprawidłowe. Sprawdź pisownię i spróbuj ponownie.",
    LOGIN_MISSING_PASSWORD: "Musisz wprowadzić prawidłowe hasło.",
    LOGIN_INVALID_FIELDS: "Musisz podać wszystkie informacje dotyczące logowania.",
    MISSING_EMAIL: "Musisz wprowadzić prawidłowy adres e-mail.",
    MISSING_NAME: "Twoje imię musi mieć co najmniej jeden znak.",
    NOT_AN_EMAIL: "Adres e-mail musi być w poprawnym formacie, np. xyz@test.com",
    LOGIN_SHORT_PASSWORD: "Twoje hasło musi mieć co najmniej 6 znaków.",
    LOGIN_PASSWORDS_DO_NOT_MATCH: "Twoje hasła nie pasują do siebie.",
    LOGIN_PASSWORD_UNSECURE: "Twoje hasło nie spełnia wymagań dotyczących bezpieczeństwa.",
    SOMETHING_WENT_WRONG: (helpEmail) => `Ups, coś poszło nie tak po naszej stronie. Spróbuj ponownie za kilka minut lub skontaktuj się z nami pod adresem ${helpEmail}, jeśli problem będzie się powtarzał.`,
    VALID_CAPTCHA_REQUIRED: "Wymagana jest poprawna odpowiedź na CAPTCHA",
    LOGIN_MISSING_NEW_PASSWORD: "Musisz wprowadzić nowe hasło.",
    LOGIN_PASSWORDS_MUST_MATCH: "Twoje hasła muszą pasować do siebie.",
    LOGIN_PASSWORD_INVALID: "Twoje nowe hasło musi spełniać kryteria bezpieczeństwa.",
    LOGIN_PASSWORD_RESET_EMAIL_SEND: "Jeśli istnieje konto o podanym przez Ciebie adresie, otrzymasz e-mail z linkiem do resetowania hasła.",
    LOGIN_PASSWORD_CHANGED: "Pomyślnie zmieniłeś swoje hasło.",
    LOGIN_NO_ROLE: (helpEmail) => `Twoje konto nie zostało poprawnie skonfigurowane. Skontaktuj się z ${helpEmail} w celu uzyskania pomocy.`,
    LOGIN_TOKEN_EXPIRED: (resetPasswordLink) => `Link do resetowania hasła, który użyłeś, nie jest już ważny. Prosimy o ponowne wygenerowanie linka tutaj: ${resetPasswordLink}`,
    LOGIN_CLICK_TO_AGREE: (conventionName) => `Klikając poniżej przycisk „Zaloguj się”, zgadzasz się na przechowywanie i wykorzystanie moich danych osobowych przez ${conventionName}, zgodnie z`,
    PASSWORDS_MUST_NOT_BE_RECENT: "Wprowadzone hasło zostało niedawno użyte, proszę użyj innego hasła.",

    // toast titles
    ERROR_TOAST_TITLE: "Błąd",
    SUCCESS_TOAST_TITLE: "Sukces",

    //survey actions
    SURVEY_SAVE_SUCCESS: "Ankieta została pomyślnie zapisana.",
    SURVEY_SAVE_ERROR: errorMessage("Nie udało się zapisać ankiety."),
    SURVEY_CONFIRM_PUBLISH: "Zamierzasz opublikować tę ankietę. Spowoduje to widoczność ankiety dla publiczności oraz umożliwi zbieranie odpowiedzi. Czy na pewno chcesz opublikować tę ankietę?",
    SURVEY_CONFIRM_CLOSE: "Zamierzasz zamknąć tę ankietę. Spowoduje to zakończenie zbierania odpowiedzi. Czy na pewno chcesz zamknąć tę ankietę?",
    SURVEY_CONFIRM_DELETE: "Czy na pewno chcesz trwale usunąć tę ankietę? Tej operacji nie można cofnąć.",
    SURVEY_SAVE_SUCCESS_PUBLISH: "Ankieta została pomyślnie opublikowana.",
    SURVEY_SAVE_ERROR_PUBLISH: errorMessage("Nie udało się opublikować ankiety."),
    SURVEY_SAVE_SUCCESS_CLOSE: "Ankieta została pomyślnie zamknięta.",
    SURVEY_SAVE_ERROR_CLOSE: errorMessage("Nie udało się zamknąć ankiety."),
    SURVEY_SAVE_SUCCESS_DELETE: "Ankieta została pomyślnie usunięta.",
    SURVEY_SAVE_ERROR_DELETE: errorMessage("Nie udało się usunąć ankiety."),
    SURVEY_SAVE_SUCCESS_ADD: "Ankieta została pomyślnie dodana.",
    SURVEY_SAVE_ERROR_ADD: errorMessage("Nie udało się dodać ankiety."),

    // survey results actions
    SURVEY_RESULTS_CLEAR_SUCCESS: "Wyniki zostały pomyślnie usunięte.",
    SURVEY_RESULTS_CLEAR_ERROR: errorMessage("Nie udało się usunąć wyników."),
    SURVEY_RESULTS_CLEAR_CONFIRM: "Spowoduje to trwałe usunięcie wszystkich odpowiedzi na tę ankietę. Czy na pewno chcesz usunąć wszystkie odpowiedzi?",
    SURVEY_RESULTS_FREEZE_SUCCESS: "Edycja odpowiedzi została pomyślnie zablokowana.",
    SURVEY_RESULTS_FREEZE_ERROR: errorMessage("Nie udało się zablokować edycji odpowiedzi."),
    SURVEY_RESULTS_UNFREEZE_SUCCESS: "Edycja odpowiedzi została pomyślnie odblokowana.",
    SURVEY_RESULTS_UNFREEZE_ERROR: errorMessage("Nie udało się odblokować edycji odpowiedzi."),

    //survey defaults
    SURVEY_DEFAULT_THANK_YOU: "Twoje odpowiedzi zostały zapisane.",

    //survey restrictions
    SURVEY_NOT_ASSIGNED: "Ta ankieta nie została przypisana do Ciebie.",

    //survey questions
    SURVEY_YESNOMAYBE_PLACEHOLDER: "Proszę podaj więcej informacji tutaj.",
    SURVEY_LINKED_FIELD: "Ta odpowiedź jest bezpośrednio powiązana z polem profilu. Wszystkie informacje z tego pola będą tu odtwarzane, a edycja tych informacji spowoduje edycję Twojego profilu. Pola powiązane mają specjalną ikonę: ",
    SURVEY_LINKED_FIELD1: "Jakiekolwiek pole oznaczone jako (",
    SURVEY_LINKED_FIELD2: ") jest bezpośrednio powiązane z polem profilu. Wszystkie informacje z tego pola są tutaj odtwarzane, a edycja tych informacji spowoduje edycję Twojego profilu.",
    
    // ogólna aplikacja
    NOT_IMPLEMENTED: "Ta funkcja nie została jeszcze zaimplementowana. Sprawdź ponownie wkrótce!",
    ADMIN_ADD_AGREEMENT_SUCCESS: (title) => `${title} pomyślnie dodany do Planoramy.`,
    ADMIN_ADD_USER_SUCCESS: (name) => `${name} pomyślnie dodany do Planoramy.`,
    ADMIN_ADD_USER_ERROR: (name) => errorMessage(`Nie udało się dodać użytkownika ${name} do Planoramy.`),
    IEA_FAILURE_TO_SIGN: "Jako członek personelu nie możesz kontynuować bez wyrażenia zgody na zasady etyki i ochrony danych.",
    MODEL_SAVE_SUCCESS: (model) => `${titleCase(model)} pomyślnie zapisany.`,
    MODEL_SAVE_ERROR: (model) => errorMessage(`Nie udało się zapisać ${titleCase(model)}.`),
    MODEL_ADD_SUCCESS: (model) => `${titleCase(model)} pomyślnie dodany.`,
    MODEL_ADD_ERROR: (model) => errorMessage(`Nie udało się dodać ${titleCase(model)}.`),
    MODEL_DELETE_SUCCESS: (model) => `${titleCase(model)} pomyślnie usunięty.`,
    MODEL_DELETE_ERROR: (model) => errorMessage(`Nie udało się usunąć ${titleCase(model)}.`),
    MODEL_MASS_UPDATE_SUCCESS: (model) => `Wszystkie ${titleCase(model)} pomyślnie zaktualizowane.`,
    MODEL_MASS_UPDATE_ERROR: (model) => errorMessage(`Nie udało się zaktualizować wszystkich ${titleCase(model)}.`),

    // Mailing messages
    MAILING_SCHEDULED: (title) => `Wysyłka ${title} została zaplanowana.`,
    MAILING_TEST_SCHEDULED: (title) => `Test wysyłki ${title} został zaplanowany.`,
    MAILING_CLONED: (title) => `Utworzono klon wysyłki ${title}.`,

    //question actions
    QUESTION_ORDER_SAVE_SUCCESS: "Pomyślnie zapisano kolejność pytań.",
    QUESTION_ORDER_SAVE_ERROR: errorMessage("Nie udało się zapisać kolejności pytań."),
    QUESTION_SAVE_SUCCESS: "Pytanie pomyślnie zapisane.",
    QUESTION_SAVE_ERROR: errorMessage("Nie udało się zapisać pytania."),
    QUESTION_DELETE_SUCCESS: "Pytanie pomyślnie usunięte.",
    QUESTION_DELETE_ERROR: errorMessage("Nie udało się usunąć pytania."),
    QUESTION_DUPLICATE_SUCCESS: "Pytanie pomyślnie zduplikowane.",
    QUESTION_DUPLICATE_ERROR: errorMessage("Nie udało się zduplikować pytania."),
    QUESTION_ADD_SAVE_SUCCESS: "Pytanie pomyślnie dodane.",
    QUESTION_ADD_SAVE_ERROR: errorMessage("Nie udało się dodać pytania."),
    QUESTION_UNCHANGED: "Zmiany w pytaniu zostały porzucone.",
    QUESTION_MODAL_MESSAGE: "Zmieniasz typ pytania, a z nim związane jest powiązane pole. Jeśli kontynuujesz zmianę typu pytania, usuniemy powiązane pole. Możesz zdecydować się pozostawić typ pytania bez zmian, a powiązanie pozostanie.",

    //answer actions
    ANSWER_ORDER_SAVE_SUCCESS: "Pomyślnie zapisano kolejność odpowiedzi.",
    ANSWER_ORDER_SAVE_ERROR: errorMessage("Nie udało się zapisać kolejności odpowiedzi."),
    ANSWER_SAVE_SUCCESS: "Odpowiedź pomyślnie zapisana.",
    ANSWER_SAVE_ERROR: errorMessage("Nie udało się zapisać odpowiedzi."),
    ANSWER_ADD_SUCCESS: "Odpowiedź pomyślnie dodana.",
    ANSWER_ADD_ERROR: errorMessage("Nie udało się dodać odpowiedzi."),

    // session interest
    SESSION_INTEREST_SUCCESS: "Zainteresowanie sesją zostało zapisane.",
    SESSION_INTEREST_ERROR: errorMessage("Nie udało się zapisać zainteresowania sesją."),
    SESSION_INTEREST_REMOVE_SUCCESS: "Zainteresowanie sesją zostało usunięte.",
    SESSION_INTEREST_REMOVE_ERROR: errorMessage("Nie udało się usunąć zainteresowania sesją."),
    SESSION_ASSIGNMENT_SUCCESS: "Przypisanie sesji zostało zapisane.",
    SESSION_ASSIGNMENT_ERROR: errorMessage("Nie udało się zapisać przypisania sesji."),
    SESSION_INTEREST_UPDATE_SUCCESS: "Zainteresowanie sesją zostało zaktualizowane.",
    SESSION_INTEREST_UPDATE_ERROR: errorMessage("Nie udało się zaktualizować zainteresowania sesją."),

    SESSION_SAVE_SUCCESS_DELETE: "Sesja została pomyślnie usunięta.",
    SESSION_SAVE_ERROR_DELETE: errorMessage("Nie udało się usunąć sesji."),
    SESSION_SAVE_SUCCESS: "Sesja została pomyślnie zapisana.",
    SESSION_SAVE_ERROR: errorMessage("Nie udało się zapisać sesji."),

    SESSION_RANKING_ERROR: (total, allowed) => `Przypisałeś/aś ${total}, co przekracza dozwoloną liczbę ${allowed}.`,

    CONFIGURATION_SAVED_SUCCESS: "Konfiguracja została zapisana.",
    CONFIGURATION_SAVED_ERROR: errorMessage("Błąd podczas zapisywania konfiguracji."),

    CREATE_SESSION_LIMIT_SUCCESS: "Limit sesji został zapisany.",
    CREATE_SESSION_LIMIT_ERROR: errorMessage("Błąd podczas zapisywania limitu sesji."),

    AVAILABILITY_DESCRIPTION: "Pod każdym dniem prosimy zaznaczyć (klikając i przeciągając), kiedy jesteś dostępny/a w widoku kalendarza poniżej.",
    SAVE_AVAILABILITY_NOTES: "Inne uwagi dotyczące harmonogramu zostały pomyślnie zapisane.",
    AVAILABILITY_NOTES_LABEL: "Inne uwagi dotyczące harmonogramu",

    UPDATE_PERSON_EXCLUSION_SUCCESS: "Informacje o wyłączeniach zostały zaktualizowane.",
    UPDATE_PERSON_EXCLUSION_ERROR: errorMessage("Błąd podczas aktualizacji informacji o wyłączeniach."),
    GET_PERSON_EXCLUSION_SUCCESS: "Informacje o wyłączeniach zostały pobrane.",
    GET_PERSON_EXCLUSION_ERROR: errorMessage("Błąd podczas pobierania informacji o wyłączeniach."),
    
    UPDATE_AVAILABILITY_SUCCESS: "Dostępność została zaktualizowana.",
    UPDATE_AVAILABILITY_ERROR: errorMessage("Błąd podczas aktualizacji dostępności."),
    
    ADD_EMAIL_SUCCESS: "Adres e-mail został dodany.",
    ADD_EMAIL_ERROR: errorMessage("Błąd podczas dodawania adresu e-mail."),
    
    //page actions
    PAGE_DELETE_SUCCESS: "Strona pomyślnie usunięta.",
    PAGE_DELETE_ERROR: errorMessage("Nie udało się usunąć strony."),
    PAGE_MERGE_SUCCESS: "Strona pomyślnie scalona.",
    PAGE_MERGE_ERROR: errorMessage("Nie udało się scalić strony."),
    SURVEY_CONFIRM_DELETE_PAGE_1: "Usunięcie strony spowoduje również usunięcie zawartych w niej pytań i opcji odpowiedzi.",
    SURVEY_CONFIRM_DELETE_PAGE_2: "Aby zachować pytania, wybierz „Scal stronę w górę” z opcji strony.",
    PAGE_ADD_SUCCESS: "Strona pomyślnie dodana.",
    PAGE_ADD_ERROR: errorMessage("Nie udało się dodać strony."),
    PAGE_SAVE_SUCCESS: "Strona pomyślnie zapisana.",
    PAGE_SAVE_ERROR: errorMessage("Nie udało się zapisać strony."),
    
    //venues
    VENUES_ADD_ROOM_SUCCESS: (name) => `${name} pomyślnie dodany.`,
    VENUES_ADD_ROOMSET_SUCCESS: (name) => `${name} pomyślnie dodany.`,
    VENUES_ADD_VENUE_SUCCESS: (name) => `${name} pomyślnie dodany.`,    

    // linked field names
    LINKED_FIELD_LABELS: {
        Person: {
            name: "Imię",
            pseudonym: "Opublikowane imię",
            pronouns: "Zaimki",
            gender: "Płeć",
            ethnicity: "Rasa i/lub pochodzenie etniczne",
            age_at_convention: "Wiek na konwencie",
            romantic_sexual_orientation: "Orientacja romantyczna i/lub seksualna",
            bio: "Biografia",
            can_stream_exceptions: "Tematy niedozwolone do transmitowania na żywo",
            can_record_exceptions: "Tematy niedozwolone do nagrywania",
            excluded_demographic_categories: "Tematy demograficzne niedozwolone do omawiania",
            accommodations: "Szczegóły dotyczące dostępności",
            moderation_experience: "Doświadczenie w moderacji",
            othered: "Osoba odmienna?",
            indigenous: "Osoba rdzenna?",
            black_diaspora: "Czarny diasporyczny?",
            global_diaspora: "Globalny diasporyczny?",
            non_us_centric_perspectives: "Perspektywy nie skoncentrowane na USA?",
            non_anglophone: "Nieanglojęzyczny?",
            demographic_categories: "Dodatkowe kategorie demograficzne",
            do_not_assign_with: "Nie przypisuj z",
            attendance_type: "Typ uczestnictwa",
            can_stream: "Zezwolenie na transmitowanie na żywo",
            can_record: "Zezwolenie na nagrywanie",
            can_photo: "Zezwolenie na fotografowanie",
            needs_accommodations: "Potrzebuje dostosowań",
            is_local: "Lokalny uczestnik",
            willing_to_moderate: "Zainteresowanie moderacją",
            languages_fluent_in: "Biegłe języki",
            contact_email: "Adres e-mail kontaktowy",
            twitter: "X (dawniej Twitter)",
            facebook: "Facebook",
            website: "Strona internetowa",
            instagram: "Instagram",
            twitch: "Twitch",
            youtube: "YouTube",
            tiktok: "TikTok",
            linkedin: "LinkedIn",
            flickr: "Flickr",
            reddit: "Reddit",
            bsky: "Bluesky",
            fediverse: "Fediverse",
            othersocialmedia: "Inne media społecznościowe",
            socialmedia: "Media społecznościowe",
            can_share: "Zezwolenie na udostępnianie adresu e-mail uczestnikom"
        },
    },

    ERROR_GENERIC_RECOVERABLE: (email) => twoLines("Serwer napotkał wewnętrzny błąd i nie był w stanie zakończyć Twojego żądania.",
        `Skontaktuj się z administratorem serwera pod adresem ${email} i podaj mu datę i godzinę wystąpienia błędu.`),
    ERROR_GENERIC_UNRECOVERABLE: (email) => twoLines("Serwer napotkał wewnętrzny błąd i nie był w stanie zakończyć Twojego żądania.",
        `Skontaktuj się z administratorem serwera pod adresem ${email} i podaj mu datę i godzinę wystąpienia błędu.`),

    ADD_CONFLICT_IGNORE_SUCCESS: "Ignorowanie konfliktu dodane",
    ADD_CONFLICT_IGNORE_ERROR: "Nie udało się dodać ignorowania konfliktu",

    // Social Links Errors
    TWITTER_ID_INVALID_MSG: "ID X (dawniej Twitter) nie jest w poprawnym formacie",
    FACEBOOK_ID_INVALID_MSG: "ID Facebooka nie jest w poprawnym formacie",
    WEBSITE_INVALID_MSG: "Strona internetowa nie jest w poprawnym formacie",
    INSTAGRAM_ID_INVALID_MSG: "ID Instagramu nie jest w poprawnym formacie",
    TWITCH_ID_INVALID_MSG: "ID Twitcha nie jest w poprawnym formacie",
    YOUTUBE_ID_INVALID_MSG: "ID YouTube'a nie jest w poprawnym formacie",
    TIKTOK_ID_INVALID_MSG: "ID TikToka nie jest w poprawnym formacie",
    LINKEDIN_ID_INVALID_MSG: "ID LinkedIna nie jest w poprawnym formacie",

    PROFILE_FIELD_LABELS: {
        ethnicity: "Etniczność",
        gender: "Płeć",
        age_at_convention: "Wiek podczas wydarzenia",
        romantic_sexual_orientation: "Orientacja romantyczna i/lub seksualna",
        othered: "Doświadczenie z byciem „inny”",
        indigenous: "Członek społeczności rdzennej",
        black_diaspora: "Członek globalnej diaspory czarnej",
        non_us_centric_perspectives: "Reprezentuje coś innego niż czysto amerykańska perspektywa",
        demographic_categories: "Inne kategorie demograficzne",
        twitter: "X (dawniej Twitter)",
        facebook: "Facebook",
        website: "Strona internetowa",
        instagram: "Instagram",
        twitch: "Twitch",
        youtube: "YouTube",
        tiktok: "TikTok",
        linkedin: "LinkedIn",
        flickr: "Flickr",
        reddit: "Reddit",
        bsky: "Bluesky",
        fediverse: "Fediverse",
        othersocialmedia: "Inne media społecznościowe",
        do_not_assign_with: "Osoby, z którymi nie powinno się ich przypisywać do panelu",
        is_local: "Mieszkaniec lokalny",
        moderation_experience: "Doświadczenie w moderowaniu",
        can_stream: "Zezwolenie na udział w programie transmitowanym na żywo",
        can_record: "Zezwolenie na udział w nagranym programie",
        can_stream_exceptions: "Wyjątki dotyczące tematów wyłączonych z transmisji na żywo",
        can_record_exceptions: "Wyjątki dotyczące tematów wyłączonych z nagrania",
        name: "Imię",
        pseudonym: "Pseudonim",
        languages_fluent_in: "Znajomość języków",
        can_share: "Zezwolenie na udostępnianie adresu e-mail innym uczestnikom",
        attendance_type: "Bierze udział w konwencie",
        timezone: "Strefa czasowa podczas konwentu",
        needs_accommodations: "Dostępność i/lub problemy z niepełnosprawnością",
        accommodations: "Szczegóły dotyczące dostępności i/lub niepełnosprawności",
        registration_number: "Numer biletu",
        global_diaspora: "Członek globalnej diaspory",
        non_anglophone: "Reprezentuje coś innego niż czysto anglojęzyczna perspektywa",
        excluded_demographic_categories: "Kategorie demograficzne uczestnika, które nie powinny być omawiane na panelach, w których uczestniczy",
    },

    PERSON_SAVE_SUCCESS: "Rekord profilu został pomyślnie zapisany",
    PERSON_NEVER_LOGGED_IN: "Nigdy nie logował się",
    PERSON_DISABLED_LINK: "Możesz połączyć tylko własne konto rejestracyjne",
    PERSON_DISABLED_UNLINK: "Możesz odłączyć tylko własne konto rejestracyjne",
    PERSON_UNLINK_SUCCESS: "Twoje konto rejestracyjne zostało odłączone.",
    PERSON_UNLINK_FAILURE: errorMessage("Coś poszło nie tak podczas odłączania Twojego konta rejestracyjnego."),
    PERSON_UNLINK_CONFIRMATION_1: "Spowoduje to odłączenie Twojego konta rejestracyjnego od Twojego konta Planorama. Nie usunie to Twoich danych z innych systemów konwentu. Jeśli później zdecydujesz się zalogować za pomocą swojego konta rejestracyjnego, to połączenie zostanie ponownie ustanowione.",
    PERSON_UNLINK_CONFIRMATION_2: "Czy na pewno chcesz wykonać tę czynność?",

    PERSON_CON_STATE: {
        not_set: "Nie ustawiono",
        applied: "Zgłoszony",
        vetted: "Zweryfikowany",
        wait_list: "Lista oczekujących",
        invite_pending: "Oczekuje na zaproszenie",
        invited: "Zaproszony",
        probable: "Prawdopodobny",
        accepted: "Zaakceptowany",
        declined: "Odrzucony",
        rejected: "Odrzucony"
    },

    PERSON_ATTENDANCE_TYPE: {
        'in person': "Osobiście",
        hybrid: "Osobiście I Online",
        virtual: "Online",
    },
    PAGE_CONTENT_SAVE_SUCCESS: "Zawartość strony pomyślnie zapisana", 
    PAGE_CONTENT_SAVE_ERROR: "Nie udało się zapisać zawartości strony",
    PAGE_CONTENT_SUCCESS_DELETE: "Zawartość strony pomyślnie usunięta.",
    PAGE_CONTENT_ERROR_DELETE: errorMessage("Nie udało się usunąć zawartości strony."),
    
    SURVEY_REDIRECT: "Niestety, ze względu na odświeżenie przeglądarki straciliśmy wszystkie odpowiedzi, które wypełniłeś. Prosimy ponownie wypełnić ankietę.",
    SURVEY_PUBLIC_NO_EDIT: "Nie możesz edytować opublikowanej ankiety. Zamknij ankietę, aby umożliwić edycję.",
    SURVEY_PUBLIC_NO_DELETE: "Nie możesz usunąć opublikowanej ankiety. Zamknij ankietę, aby umożliwić usunięcie.",
    SESSION_ENVIRONMENT: {
        unknown: "Nieznane",
        in_person: "Osobiście",
        hybrid: "Hybrydowo",
        virtual: "Online"
    },
    SESSION_STATUS: {
        draft: "Szkic",
        reviewed: "Zrewidowane",
        revised: "Poprawione",
        dropped: "Odrzucone",
    },
    SESSION_NO_TAGS: (tagName) => `Kliknij ołówek, aby dodać ${tagName}`,
    SESSION_MUST_UNSCHEDULE: "Należy odplanować sesję, zanim ją odrzucisz",
    SESSION_MUST_UNDROP: "Należy cofnąć odrzucenie sesji, aby można było ją zaplanować ponownie.",
    SESSION_MINORS_PARTICIPATION: {
        kids_observe: "Dzieci mogą obserwować",
        kids_supervision: "Dzieci mogą uczestniczyć pod nadzorem",
        kids_participate: "Dzieci mogą uczestniczyć",
        geared_families: "Dla rodzin",
        geared_kids: "Dla dzieci",
    },
    SCHEDULE_DRAFT_CONFIRM_MESSAGE: "To spowoduje opublikowanie wersji roboczej harmonogramu dla wszystkich uczestników, którzy zobaczą swoje sesje. Ta czynność jest nieodwracalna i spowoduje krótkotrwałe wyłączenie serwera. Prosimy dwukrotnie sprawdzić, czy chcesz wykonać tę czynność.",
    SCHEDULE_FIRM_CONFIRM_MESSAGE: "To spowoduje opublikowanie ostatecznej wersji harmonogramu dla wszystkich uczestników, którzy zobaczą swoje sesje - na żywo. Ta czynność jest nieodwracalna. Prosimy dwukrotnie sprawdzić, czy chcesz wykonać tę czynność.",
    SCHEDULE_DRAFT_SUCCESS_MESSAGE: "Wersja robocza harmonogramu została pomyślnie opublikowana",
    SCHEDULE_FIRM_SUCCESS_MESSAGE: "Ostateczna wersja harmonogramu została pomyślnie opublikowana",
    SCHEDULE_APPROVAL_FAIL_TO_LOAD: "Nie udało się załadować formularza zatwierdzenia. Spróbuj ponownie za chwilę.",
    // The below is intended to become a way to override defaults in the model mixin easily. Hasn't happened yet though.
    SPECIFIC_MODEL_SAVE_SUCCESS: {
        person_schedule_approval: {
            person_schedule_approval: "Zatwierdzenie harmonogramu zapisane.",
            approved: (approvalType) => `${titleCase(approvalType)} zatwierdzenie zostało pomyślnie zapisane.`,
            comments: (approvalType) => `${titleCase(approvalType)} komentarz zatwierdzenia został pomyślnie zapisany.`,
        },
    },
    SPECIFIC_MODEL_SAVE_ERROR: {
        person_schedule_approval: {
            person_schedule_approval: errorMessage("Zatwierdzenie harmonogramu nie zostało zapisane."),
            approved: (approvalType) => errorMessage(`Zatwierdzenie ${titleCase(approvalType)} nie zostało zapisane.`),
            comments: (approvalType) => errorMessage(`Komentarz zatwierdzenia ${titleCase(approvalType)} nie został zapisany.`),
        },
    },
    EVENT_SETTINGS_MUST_RELOAD: "*** Zmiany w tych ustawieniach zostaną wprowadzone dopiero po ponownym załadowaniu strony przeglądarki. ***",
    CONFIGURATION_LABEL_OVERRIDES: {
        event_virtual: "Czy to wydarzenie zawiera komponent online?",
        clyde_base_url: "Bazowy adres URL dla Clyde",
        profile_show_info_demographic_community: "Wyświetlaj dane demograficzne, społecznościowe i informacyjne w profilu"
    }    
}
