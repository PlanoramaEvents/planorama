require 'rails_helper'

RSpec.describe Person, '#factories' do
    context 'person' do
        it 'creates a person' do
            person = create(:person)
            expect(person.invite_status).to eq "not_set"
            expect(person.acceptance_status).to eq "unknown"
            expect(person.email).to_not be_nil
            expect(person.opted_in).to be false
            expect(person.registered).to be false
            expect(person.can_share).to be false
            expect(person.can_photo).to be false
            expect(person.can_record).to be false
            expect(person.published_name).to eq "#{person.first_name} #{person.last_name}"
            expect(person.published_last_name).to eq person.last_name
        end
        it 'tries to create a person with a blank last name' do         #last_name should be a required field and non-blank
            expect { person = create(:person, last_name: '') }.to raise_error(ActiveRecord::RecordInvalid)
        end
        it 'tries to create a person with a blank first name' do
            person = create(:person, first_name: '')
            expect(person.first_name).to be_nil
            expect(person.first_name).to_not eq ""
        end
    end

    context 'pseudonym_person' do
        it 'creates a person with a published first and last name' do
            person = create(:pseudonym_person)
            expect(person.published_name).to eq "#{person.pseudonym_first_name} #{person.pseudonym_last_name}"
            expect(person.published_last_name).to eq person.pseudonym_last_name
        end
        it 'creates a person with a published first name only' do
            person = create(:pseudonym_person, pseudonym_last_name: '')
            expect(person.published_name).to eq "#{person.pseudonym_first_name}"
        end
        it 'creates a person with a published last name only' do
            person = create(:pseudonym_person, pseudonym_first_name: '')
            expect(person.published_name).to eq "#{person.pseudonym_last_name}"
        end
    end

    context 'registered_person' do
        it 'creates a registered person' do
            person = create(:registered_person)
            expect(person.registered).to be true
            expect(person.registration_type).to be_truthy
            expect(person.registration_number).to be_truthy
        end
    end
end
