require 'rails_helper'
RSpec.describe 'ユーザ機能', type: :system do
  let!(:user){FactoryBot.create(:user)}
  let!(:second_user){FactoryBot.create(:second_user)}

  describe 'ユーザ登録のテスト' do
    context 'ユーザを新規作成した場合' do
      it 'ユーザの新規登録がされる' do
        visit new_user_path
        fill_in 'user[name]', with: '一般ユーザ'
        fill_in 'user[email]', with: 'ippan@gmail.com'
        fill_in 'user[password]', with: '12345678'
        fill_in 'user[password_confirmation]', with: '12345678'
        click_button 'Create my account'
        expect(page).to have_content '一般ユーザ'
      end

      it 'ログインしていない場合、タスク一覧画面にアクセスできない' do
        visit tasks_path
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'セッション機能のテスト' do
    context 'ログインした場合' do
      it '自分のタスク一覧が表示される' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        expect(page).to have_content 'Tasks'
      end
    end

    context 'ログインした場合' do
      it '自分の詳細画面(マイページ)に飛べる' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        click_link 'Profile'
        expect(page).to have_content '一般ユーザのページ'
      end
    end

    context '一般ユーザが他人の詳細画面に飛ぶ場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit user_path(second_user)
        visit tasks_path
        expect(page).to have_content 'Tasks'
      end
    end

    context 'ログアウト' do
      it 'タスク一覧画面に遷移する' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        click_link 'Logout'
        expect(page).to have_content 'Login'
      end
    end
  end

  describe '管理者機能のテスト' do
    context '管理ユーザが管理画面にアクセスする場合' do
      it 'アクセスできる' do
        visit new_session_path
        fill_in 'session[email]', with: 'kanrisya@gmail.com'
        fill_in 'session[password]', with: '87654321'
        click_on "Log in"
        visit tasks_path
        click_link 'UserList'
        expect(page).to have_content 'ユーザー管理画面'
      end
    end

    context '一般ユーザが管理画面にアクセスする場合' do
      it 'アクセスできない' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_on "Log in"
        visit admin_users_path
        expect(page).to have_content '管理者以外はアクセスできません'
      end
    end

    context '管理ユーザがユーザの新規登録を行う場合' do
      it '登録できる' do
        visit new_session_path
        fill_in 'session[email]', with: 'kanrisya@gmail.com'
        fill_in 'session[password]', with: '87654321'
        click_on "Log in"
        visit tasks_path
        click_link 'UserList'
        click_link 'ユーザーを登録する'
        visit new_admin_user_path
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@gmail.com'
        fill_in 'user[password]', with: '12345678'
        fill_in 'user[password_confirmation]', with: '12345678'
        click_on "Create my account"
        expect(page).to have_content 'ユーザー登録が完了しました'
      end
    end

    context '管理ユーザがユーザの詳細画面にアクセスする場合' do
      it 'アクセスできる' do
        visit new_session_path
        fill_in 'session[email]', with: 'kanrisya@gmail.com'
        fill_in 'session[password]', with: '87654321'
        click_on "Log in"
        visit tasks_path
        click_link 'UserList'
        visit admin_user_path(user)
        expect(page).to have_content "一般ユーザ"
      end
    end

    context '管理ユーザがユーザの編集画面にアクセスする場合' do
      it 'ユーザを編集できる' do
        visit new_session_path
        fill_in 'session[email]', with: 'kanrisya@gmail.com'
        fill_in 'session[password]', with: '87654321'
        click_on "Log in"
        visit tasks_path
        click_link 'UserList'
        visit edit_admin_user_path(user)
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@gmail.com'
        fill_in 'user[password]', with: '12345678'
        fill_in 'user[password_confirmation]', with: '12345678'
        click_on "Update"
        expect(page).to have_content "ユーザー情報を更新しました"
      end
    end

    context '管理ユーザがユーザの削除をする場合' do
      it 'ユーザを削除できる' do
        visit new_session_path
        fill_in 'session[email]', with: 'kanrisya@gmail.com'
        fill_in 'session[password]', with: '87654321'
        click_on "Log in"
        visit tasks_path
        click_link 'UserList'
        visit admin_users_path
        # page.all('削除')[1]
        accept_confirm do
          click_link '削除', match: :first
        end
        expect(page).to have_content "削除しました"
      end
    end
  end
end