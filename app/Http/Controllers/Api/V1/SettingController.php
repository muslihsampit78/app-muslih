<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\SettingResource;
use App\Models\Setting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SettingController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Setting::query();

        if ($request->filled('group')) {
            $query->where('group', $request->query('group'));
        }

        $settings = $query->get();

        $keyed = [];
        foreach ($settings as $setting) {
            $res = new SettingResource($setting);
            $keyed[$setting->key] = $res->toArray($request)['value'];
        }

        return response()->json([
            'data' => SettingResource::collection($settings),
            'meta' => [
                'values' => $keyed,
            ],
        ]);
    }
}
