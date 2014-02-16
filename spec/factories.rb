FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end
  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2 do
    name "anonymous Fin"
    year 1910
  end
  factory :beerclub, class: BeerClub do
    name "Boolikerho"
    founded 1990
    city "Helsinki"
  end
end

