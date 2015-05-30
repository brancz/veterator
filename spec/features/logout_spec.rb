feature 'User signs out' do
  scenario 'it redirects to login form when logging out' do
    sign_in
    visit root_path

    find('#btn-logout').click
    expect(URI.parse(current_url).path).to eq new_user_session_path
  end
end
