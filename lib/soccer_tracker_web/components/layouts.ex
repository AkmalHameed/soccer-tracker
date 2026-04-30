defmodule SoccerTrackerWeb.Layouts do
  use SoccerTrackerWeb, :html

  embed_templates "layouts/*"

  attr :flash, :map, required: true
  attr :current_scope, :map, default: nil
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar bg-base-300 px-4 sm:px-6 lg:px-8 shadow-lg sticky top-0 z-50">
      <div class="flex-1">
        <a href="/" class="flex items-center gap-2">
          <span class="text-2xl">⚽</span>
          <span class="text-xl font-bold text-primary">Soccer<span class="text-base-content">Tracker</span></span>
        </a>
      </div>
      <div class="flex-none gap-2">
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
                <.link href={~p"/users/log-out"} method="delete" class="text-error">
                  🚪 Log out
                </.link>
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

  attr :flash, :map, required: true
  attr :id, :string, default: "flash-group"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <div class="relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />
      <button class="flex p-2 cursor-pointer w-1/3" phx-click={JS.dispatch("phx:set-theme")} data-phx-theme="system">
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
      <button class="flex p-2 cursor-pointer w-1/3" phx-click={JS.dispatch("phx:set-theme")} data-phx-theme="light">
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
      <button class="flex p-2 cursor-pointer w-1/3" phx-click={JS.dispatch("phx:set-theme")} data-phx-theme="dark">
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
