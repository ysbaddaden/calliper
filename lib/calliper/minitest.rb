begin
  block = lambda do
    Calliper.driver.quit if Calliper.driver?
  end

  if Minitest.respond_to?(:after_run)
    Minitest.after_run(&block)
  else
    Minitest::Unit.after_tests(&block)
  end
end
