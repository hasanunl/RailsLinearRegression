module PriceModel
  def build
    salaries = Salary.all.to_a

    # divide into training and test set
    rng = Random.new(1)
    train_set, test_set = salaries.partition { rng.rand < 0.7 }

    # handle outliers and missing values
    #train_set = preprocess(train_set)

    # train
    train_features = train_set.map { |v| features(v) }
    train_target = train_set.map { |v| target(v) }
    model = Eps::Regressor.new(train_features, train_target)
    puts model.summary

    # evaluate
    test_features = test_set.map { |v| features(v) }
    test_target = test_set.map { |v| target(v) }
    metrics = model.evaluate(test_features, test_target)
    puts "Test RMSE: #{metrics[:rmse]}"

    # finalize
    #houses = preprocess(houses)
    all_features = salaries.map { |h| features(h) }
    all_target = salaries.map { |h| target(h) }
    @model = Eps::Regressor.new(all_features, all_target)

    # save
    #File.open(model_file, "w") { |f| f.write(@model.json) }
  end

  def predict(salarie)
    model.predict(features(salarie))
  end

  private

  #def preprocess(train_set)
   # train_set.reject { |h| h.experience.nil? }
  #end

  def features(salaries)
    {
      experience: salaries.experience
    }
  end

  def target(salaries)
    salaries.salary
  end

  def model
    @model ||= Eps::Regressor.load_json(File.read(model_file))
  end

  def model_file
    Rails.root.join("app", "stats_models", "price_model.json")
  end

  extend self # make all methods class methods
end