# Laravel REST + MCP with Shared Sanctum Tokens

## Goal

Expose both channels with the same Laravel Sanctum Bearer tokens:

```text
REST: /api/...
MCP:  /mcp/...
Authorization: Bearer <token>
```

Users may create multiple personal tokens. Every token must work for both REST and MCP.

## Rules

* Put REST routes in `routes/api.php`.
* Put MCP routes in `routes/ai.php`.
* Protect both with `auth:sanctum`.
* Do not create separate REST and MCP token types.
* Do not make MCP call REST endpoints over HTTP.
* REST controllers and MCP tools must call the same Action/Service classes.
* Keep authorization, ownership, and tenant filtering in Actions/Policies.

## Setup

```bash
php artisan install:api
composer require laravel/mcp
php artisan vendor:publish --tag=ai-routes
php artisan migrate
```

Ensure `User` uses `HasApiTokens`:

```php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens;
}
```

## Routes

`routes/api.php`

```php
use App\Http\Controllers\OrderController;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('orders', OrderController::class);
});
```

`routes/ai.php`

```php
use App\Mcp\Servers\OrderServer;
use Laravel\Mcp\Facades\Mcp;

Mcp::web('/mcp/orders', OrderServer::class)
    ->middleware('auth:sanctum');
```

## Shared Business Logic

Create Actions for domain logic:

```php
final class ListOpenOrders
{
    public function handle(User $user)
    {
        return Order::query()
            ->where('account_id', $user->account_id)
            ->where('status', 'open')
            ->latest()
            ->get();
    }
}
```

Both REST controllers and MCP tools must inject and call this Action. Do not duplicate queries, permissions, or domain logic.

## Token Management

Manage tokens only from the authenticated web account area, not through Bearer-token endpoints.

```php
$plainTextToken = $request->user()
    ->createToken($request->string('name'))
    ->plainTextToken;
```

Requirements:

* Allow multiple tokens per user.
* Show the raw token only once.
* Allow revoking individual tokens.
* Limit tokens per user, e.g. 10.
* Never allow an existing Bearer token to create more tokens.
* Token validity is shared across REST and MCP.

## Authorization

A valid token only identifies the user.

Always enforce access through Policies, ownership checks, and tenant/account scopes:

```text
Bearer token
→ authenticated user
→ policy + ownership + tenant scope
→ allowed or 403
```

## Validation

```text
GET  /api/orders          + Bearer token → success
POST /mcp/orders          + Bearer token → success
Any protected endpoint    without token  → 401 Unauthorized
```
