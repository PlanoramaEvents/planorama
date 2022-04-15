namespace :chicon do
  desc "Seed Chicon Data"
  task seed_exclusions: :environment do
    if Exclusion.count == 0
      Exclusion.create!(
        [
          {
            title: 'Hugo Award Ceremony'
          },
          {
            title: 'Hugo Award Ceremony rehearsal'
          },
          {
            title: 'Masquerade'
          },
          {
            title: 'Masquerade rehearsal'
          },
          {
            title: 'Opening Ceremony'
          },
          {
            title: 'Closing Ceremony'
          },
          {
            title: 'WSFS Business Meeting'
          },
          {
            title: 'Mark Protection Committee meetings'
          },
          {
            title: 'Joe Siclari and Edie Stern GoH highlight session'
          },
          {
            title: 'Floyd Norman highlight session'
          },
          {
            title: 'Erle Korshak highlight session'
          },
          {
            title: 'Eve L. Ewing highlight session'
          },
          {
            title: 'Gene Ha highlight session'
          },
          {
            title: 'Eric Wilkerson highlight session'
          }
        ]
      )
    end
  end
end
