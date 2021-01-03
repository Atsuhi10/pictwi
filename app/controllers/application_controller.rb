class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # devise_action?はTrue/Falseを返すdeviseのメソッドで、その名の通り呼び出されているコントローラがdeviseに属するものであるか否かを表す。
  # したがってこの一行全体でdeviseのコントローラが呼ばれた場合のみconfigure_permitted_parametersなるメソッドを呼び出すことになる。
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    # そもそも初期状態のdeviseでsign_up (devise/registrations#new)などのアクションが行われる際にはメールアドレスとパスワードしかサーバー側で受け取られない。
    # ここへ任意のパラメータを追加するのがdeviseで提供される本メソッド。Gemの中身を書き換えるようなことはしない。
    # 第一引数がパラメータを追加したいアクション名、第二引数が追加するキーになる。
  end
end
