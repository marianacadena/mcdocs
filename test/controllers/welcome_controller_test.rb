require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get welcome_index_url
    assert_response :success
    assert_select "body", "You're on Rails!"
  end

  def autenticacion
    academico = Academico.find(1)
    assert_equal "marhcr18@gmail.com", academico.email
  end

end
