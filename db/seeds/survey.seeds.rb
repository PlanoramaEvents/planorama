#surveys


Survey.delete_all

3.times.each do |i|
    s = Survey.create(
        name: 'Survey # ' + i.to_s,
        welcome: Faker::Movies::Hobbit.quote,
        thank_you: 'Thank you for responding.',
        public: true,
        authenticate: Faker::Boolean.boolean(true_ratio: 0.9)

        #alias character varying(191),
        #submit_string character varying DEFAULT 'Save'::character varying,
        #header_image character varying DEFAULT ''::character varying,
        #use_captcha boolean DEFAULT false,
        #transition_accept_status public.acceptance_status_enum,
        #transition_decline_status public.acceptance_status_enum,
        #declined_msg text,
        #authenticate_msg text,
        #anonymous boolean DEFAULT false
    )

end


p "Created #{Survey.count} surveys."
