def app(assigns) do
  ~H"""
  <header class="navbar bg-base-300 px-4 sm:px-6 lg:px-8 shadow-lg sticky top-0 z-50">
    <div class="flex-1">
      <a href="/" class="flex items-center gap-2">
        <span class="text-2xl">⚽</span>
        <span class="text-xl font-bold text-primary">Soccer<span class="text-base-content">Tracker</span></span>
      </a>
    </div>
    <div class="flex items-center gap-2">
      <%= if @current_scope do %>
        <ul class="hidden lg:flex items-center gap-1">
          <li><a href={~p"/dashboard"} class="btn btn-ghost btn-sm">Dashboard</a></li>
          <li><a href={~p"/games"} class="btn btn-ghost btn-sm">Matches</a></li>
          <li><a href={~p"/sessions"} class="btn btn-ghost btn-sm">Sessions</a></li>
          <li><a href={~p"/library"} class="btn btn-ghost btn-sm">Drills</a></li>
          <li><a href={~p"/programs"} class="btn btn-ghost btn-sm">Programs</a></li>
          <li><a href={~p"/teams"} class="btn btn-ghost btn-sm">Teams</a></li>
          <li><a href={~p"/goals"} class="btn btn-ghost btn-sm">Goals</a></li>
        </ul>
        <div class="dropdown dropdown-end">
          <div tabindex="0" role="button" class="btn btn-ghost btn-circle">
            <div class="w-9 h-9 rounded-full bg-primary flex items-center justify-center text-primary-content font-bold text-sm">
              {String.upcase(String.slice(@current_scope.user.email, 0, 1))}
            </div>
          </div>
          <ul tabindex="0" class="dropdown-content menu bg-base-200 rounded-box z-50 mt-3 w-56 p-2 shadow-xl border border-base-300">
            <li class="px-3 py-2 text-xs opacity-50 truncate">{@current_scope.user.email}</li>
            <div class="divider my-0"></div>
            <li class="lg:hidden"><a href={~p"/dashboard"}>🏠 Dashboard</a></li>
            <li class="lg:hidden"><a href={~p"/games"}>🏟️ Matches</a></li>
            <li class="lg:hidden"><a href={~p"/sessions"}>📋 Sessions</a></li>
            <li class="lg:hidden"><a href={~p"/library"}>📚 Drills</a></li>
            <li class="lg:hidden"><a href={~p"/programs"}>📅 Programs</a></li>
            <li class="lg:hidden"><a href={~p"/teams"}>👥 Teams</a></li>
            <li class="lg:hidden"><a href={~p"/goals"}>🎯 Goals</a></li>
            <li><a href={~p"/users/settings"}>⚙️ Settings</a></li>
            <li>
              <form action={~p"/users/log-out"} method="post" style="margin:0">
                <input type="hidden" name="_method" value="delete" />
                <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
                <button type="submit" class="w-full text-left text-error">
                  🚪 Log out
                </button>
              </form>
            </li>
          </ul>
        </div>
      <% else %>
        <a href={~p"/users/register"} class="btn btn-ghost btn-sm">Register</a>
        <a href={~p"/users/log-in"} class="btn btn-primary btn-sm">Log in</a>
      <% end %>
      <.theme_toggle />
    </div>
  </header>

  <main class="px-4 py-8 sm:px-6 lg:px-8">
    <div class="mx-auto max-w-6xl">
      {render_slot(@inner_block)}
    </div>
  </main>

  <.flash_group flash={@flash} />
  """
end
