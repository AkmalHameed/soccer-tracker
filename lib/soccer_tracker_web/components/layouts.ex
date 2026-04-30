defmodule SoccerTrackerWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use SoccerTrackerWeb, :html

  embed_templates "layouts/*"

  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar bg-base-300 px-4 sm:px-6 lg:px-8 shadow-lg">
      <div class="flex-1">
        <a href="/" class="flex items-center gap-2">
          <span class="text-2xl">⚽</span>
          <span class="text-xl font-bold text-primary">Soccer Tracker</span>
        </a>
      </div>
      <div class="flex-none">
        <ul class="flex items-center gap-2">
          <%= if @current_scope do %>
            <li><a href={~p"/dashboard"} class="btn btn-ghost btn-sm">🏠 Dashboard</a></li>
            <li><a href={~p"/games"} class="btn btn-ghost btn-sm">🏟️ Matches</a></li>
            <li><a href={~p"/sessions"} class="btn btn-ghost btn-sm">📋 Sessions</a></li>
            <li><a href={~p"/library"} class="btn btn-ghost btn-sm">📚 Drills</a></li>
            <li><a href={~p"/programs"} class="btn btn-ghost btn-sm">📅 Programs</a></li>
            <li><a href={~p"/teams"} class="btn btn-ghost btn-sm">👥 Teams</a></li>
            <li><a href={~p"/goals"} class="btn btn-ghost btn-sm">🎯 Goals</a></li>
            <li class="ml-2 border-l border-base-content/20 pl-2">
              <a href={~p"/users/settings"} class="btn btn-ghost btn-sm opacity-60">⚙️</a>
            </li>
            <li>
              <a href={~p"/users/log-out"} class="btn btn-ghost btn-sm">Log out</a>
            </li>
          <% else %>
            <li>
              <a href={~p"/users/register"} class="btn btn-ghost btn-sm">Register</a>
            </li>
            <li>
              <a href={~p"/users/log-in"} class="btn btn-primary btn-sm">Log in</a>
            </li>
          <% end %>
          <li>
            <.theme_toggle />
          </li>
        </ul>
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

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

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
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
